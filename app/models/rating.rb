class Rating < ActiveRecord::Base
  POSSIBLE_STATES = %w{pending rejected approved}

  before_validation do
    # Default values
    self.state ||= POSSIBLE_STATES.first
  end

  validates_inclusion_of :number, :in => 1..10
  validates :state, inclusion: {in: POSSIBLE_STATES}
  validates :review, presence: true, length: {minimum: 4, maximum: 100}

  scope :latest, -> { order(created_at: :desc) }
  scope :pending, -> { where(state: :pending) }
  scope :approved, -> { where(state: :approved) }

  belongs_to :book
  belongs_to :user
end
