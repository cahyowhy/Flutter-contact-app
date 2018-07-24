class UserSerializer < BaseSerializer
  attributes :id, :name, :surname, :address, :dob, :about, :image_profile, :contacts, :created_at

  def contacts
    if instance_options[:show_contact]
      contacts = []
      object.contacts.each do |item|
        contacts.push(ContactSerializer.new(item))
      end

      contacts
    else
      []
    end
  end
end