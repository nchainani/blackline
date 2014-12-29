class PassSerializer < ActiveModel::Serializer
  attributes :id, :status, :rider_id, :total_tickets, :remaining_tickets, :pass_plan, :amount, :currency
  attributes :type

  def type
    'pass'
  end

  def pass_plan
    PassPlanSerializer.new(object.pass_plan, root: false)
  end
end
