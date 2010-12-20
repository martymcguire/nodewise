require 'date'

class Membership < ActiveRecord::Base
  include ActiveRecord::Transitions

  # Day of the month that payments are due
  PAYMENT_DUE_ON = 20
  before_save :set_next_payment_due

  attr_protected :user_id, :state, :next_payment_due

  belongs_to :user
  validates_uniqueness_of :user_id

  state_machine do
    # a :preactive member can update their profile but cannot pay, participate
    # in voting, or access the space.
    state :preactive

    # an :active member is a full participant in the space
    state :active

    # a :suspended member can pay but not participate
    state :suspended

    # an :inactive member has closed their account and ended their membership.
    state :inactive

    event :activate do
      transitions :to => :active, :from => [:preactive, :suspended, :inactive], :on_transition => :do_activation
    end

    event :deactivate do
      transitions :to => :inactive, :from => [:active, :preactive], :on_transition => :do_deactivation
    end

    event :suspend do
      transitions :to => :suspended, :from => [:active], :on_transition => :do_suspension # , :guard => lambda { |product| product.in_stock > 0 }
    end
  end

  def do_activation
    # prepare alerts
    # schedule payment
  end

  def self.next_payment_date
    next_payment = DateTime.now
    next_payment = next_payment + 1.month if next_payment.day > PAYMENT_DUE_ON
    
    DateTime.new next_payment.year, next_payment.month, PAYMENT_DUE_ON
  end

  def set_next_payment_due
    if self.next_payment_due.nil?
      self.next_payment_due = self.class.next_payment_date
    end
  end

end
