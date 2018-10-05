require 'json'

class Contact
    attr_accessor :firstname, :lastname, :email, :address, :tel
    @@contacts = []

    def self.all_contacts
        @@contacts
    end

    def self.count_contacts
        all_contacts.count
    end

    def initialize(info)
        @firstname, @lastname, @email, @address, @tel = info[0].capitalize,info[1].capitalize,info[2],info[3],info[4]
        # self.class.all_contacts << self
    end

    def self.add_contact(info)
        new(info).tap {|contact| all_contacts << contact}
        # c.class.all_contacts << self
        "#{info[0]} #{info[1]} succefuly add to your contact"
    end

    def self.add_all_contacts(json)
        all_contacts.clear
        return if json.empty?
        contacts = JSON.parse(json)
        contacts.each do |contact|
            new(contact).tap {|contact| all_contacts << contact}
        end
    end

    def self.sort_contacts
        all_contacts.sort! { |person1, person2| person1.firstname <=> person2.firstname }
    end

    def self.show_contacts_choosen
        sort_contacts
        all_contacts.each.with_index(1).map do |person, index|
            "#{index}. #{person.firstname} #{person.lastname}"
        end.join("\n")
    end

    def self.show_all_contacts(sort="asc")
        sort_contacts #if sort == "asc"
        all_contacts.sort! { |person1, person2| person2.firstname <=> person1.firstname } if sort == "desc"
        all_contacts.each.with_index(1).map do |person, index|
            ["#{index}.","#{person.firstname} #{person.lastname}", person.email, person.address, person.tel]
        end
    end

    def self.edit_contact(index, info)
        new(info).tap {|contact| all_contacts[index-1] = contact}
        # all_contacts[index-1] = person
        "#{info[0]} #{info[1]} has been succefuly edited in your contact"
    end

    def self.delete_contact(index)
        fname, lname = all_contacts[index-1].firstname, all_contacts[index-1].lastname # added
        all_contacts.delete_at(index-1)
        "#{fname} #{lname} has been succefuly deleted in your contact" #modifed
    end

    def self.delete_all_contacts
        all_contacts.clear
    end

    def self.to_json
        contacts = all_contacts.map do |contact|
            [contact.firstname, contact.lastname, contact.email, contact.address, contact.tel]
        end
        JSON.generate(contacts)
    end
end