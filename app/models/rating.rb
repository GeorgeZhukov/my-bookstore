class Rating < ActiveRecord::Base

  before_validation do
    # Default values
    self.state ||= :pending
  end

  validates :number, presence: true, inclusion: {in: 1..10}
  # validates :state, inclusion: {in: POSSIBLE_STATES}
  validates :review, presence: true, length: {minimum: 4, maximum: 100}
  validates :user, presence: true
  validates :book, presence: true

  delegate :avatar_url, to: :user, prefix: true

  default_scope { order(created_at: :desc) }

  scope :pending, -> { where(state: :pending) }
  scope :approved, -> { where(state: :approved) }

  belongs_to :book
  belongs_to :user

  state_machine :state, initial: :pending do

    event :approve do
      transition :pending => :approved
    end

    event :reject do
      transition [:pending, :approved] => :rejected
    end

    state :pending
    state :approved
    state :rejected
  end

end
