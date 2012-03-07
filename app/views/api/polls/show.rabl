object @poll
attributes :id, :question, :state, :start_date, :end_date
child(:choices) { attributes :content, :votes }
