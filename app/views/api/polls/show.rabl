object @poll
attributes :id, :question, :state, :start_date, :end_date, :created_at, :updated_at
child(:choices) { attributes :content, :votes }
