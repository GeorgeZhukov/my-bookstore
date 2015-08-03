class Rating < ActiveRecord::Base
  include AASM

  before_validation do
    # Default values
    self.state ||= :pending
  end

  validates_inclusion_of :number, :in => 1..10
  # validates :state, inclusion: {in: POSSIBLE_STATES}
  validates :review, presence: true, length: {minimum: 4, maximum: 100}

  scope :latest, -> { order(created_at: :desc) }
  scope :pending, -> { where(state: :pending) }
  scope :approved, -> { where(state: :approved) }

  belongs_to :book
  belongs_to :user

  aasm column: "state" do
    state :pending, initial: true
    state :approved
    state :rejected

    event :approve do
      transitions from: [:pending, :rejected], to: :approved
    end

    event :reject do
      transitions from: [:pending, :approved], to: :rejected
    end
  end

  rails_admin do
    list do
      field :state, :state
    end
    edit do
      field :state, :state
    end

    state({
              events: {approve: 'btn-success', reject: 'btn-danger'},
              states: {pending: 'label-info', rejected: 'label-danger', approved: 'label-success'}
          })
  end

end
