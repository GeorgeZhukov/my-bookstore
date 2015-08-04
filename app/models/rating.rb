class Rating < ActiveRecord::Base

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
