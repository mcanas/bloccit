module LabelsHelper
  def labels_to_buttons(labels)
    raw labels.map { |label| link_to label.name, label_path(id: label.id), class: 'btn-xs btn-primary' }.join(' ')
  end
end
