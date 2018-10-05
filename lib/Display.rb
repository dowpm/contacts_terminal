require '../lib/Contact'
require 'terminal-table'

class Display
    FILENAME = "contact.json"
    ADDCONTACTSTAPE = ["Enter the firstname","Enter the lastname","Enter the email","Enter the address","Enter the phone number"]
    EDITCONTACTSTAPE = ["Enter the new firstname","Enter the new lastname","Enter the new email","Enter the new address","Enter the new phone number"]
    CHOICES = ["1. Add a contact", "2. Show contacts asc", "3. Show contacts desc", "4. Edit a contact", "5. Delete a contact", "6. Exit to My_contact", "\n"]
    def self.load_contacts 
        File.read("../#{FILENAME}") if File.exists?("../#{FILENAME}")
    end
    
    def self.save_contacts(json_contacts)
        File.open("../#{FILENAME}","w+") do |f|
            f.write(json_contacts)
        end
    end

    def self.start
        system "clear" or system "cls"
        puts "Welcome to My_Contact"
        Contact.add_all_contacts load_contacts
        puts "You have #{Contact.count_contacts} contact(s)","** You can type !q to back to the menu **"
        puts "-----------------------------------------------","Choose an option:"
        "show_option"
    end

    def self.check_for_contact opt
        system "clear" or system "cls"
        if Contact.count_contacts == 0
            puts " You have no contact to #{opt} yet","\n","Choose an option:"
            show_option
        end
    end

    def self.show_option 
        puts CHOICES
        option = gets.strip.to_i
        while option <= 0 || option > 6
            system "clear" or system "cls"
            puts "Option out of range", "Please choose an option:","\n"
            puts CHOICES
            option = gets.strip.to_i
        end

        case option
        when 1
            system "clear" or system "cls"
            add_contact
        when 2, 3
            check_for_contact "see"
            row_header = ["No", "Fullname","Email","Address","Phone number"]
            row_table = Contact.show_all_contacts if option == 2
            row_table = Contact.show_all_contacts("desc") if option == 3
            table = Terminal::Table.new :headings => row_header, :rows => row_table
            puts table
            puts "\n","Choose an option:"
            "show_option"
        when 4
            check_for_contact "edite"
            edit_contact
        when 5
            check_for_contact "delete"
            delete_contact
        when 0, 6
            puts "Do you really want to exit (Y/N)"
            exi = gets.strip.upcase
            if exi == "N" or exi == "NO"
                return "start"
            end
            puts "Byeeeeeee"
            save_contacts(Contact.to_json)
            "exit"
        end
    end
    
    def self.add_contact
        info, correct = [], ""
        ADDCONTACTSTAPE.each do |stape|
            puts "\n",stape
            inf = gets.strip
            if inf.upcase == "!Q"
                save_contacts(Contact.to_json)
                return "start"
            end
            info << inf
        end
        system "clear" or system "cls"
        while correct.empty?            
            info.each {|i| print "#{i} \t"}
            puts "\n","Is Everything correct? (Y/N)"
            correct = gets.strip.upcase
            if correct != "Y" && correct != "N" && correct != "YES" && correct != "NO"
                puts "\n", "Bad choice", "\n"
                correct = ""
            end
        end
        system "clear" or system "cls"
        return "add_contact" if correct == "N" or correct == "NO"
        puts Contact.add_contact(info) if correct == "Y" or correct == "YES"
        puts "Now you have #{Contact.count_contacts} contact(s)","Choose an option:","\n"
        "show_option"
    end

    def self.edit_contact
        info, correct = [], ""
        
        puts "Choose the contact to edite:","** You can type !q to back to the menu **",Contact.show_contacts_choosen,"\n"
        index = gets.strip
        if index.upcase == "!Q"
            save_contacts(Contact.to_json)
            return "start"
        end
        index = index.to_i
        if index < 1 or index > (Contact.count_contacts)
            system "clear" or system "cls"
            return "edit_contact"
        end
        data = [Contact.all_contacts[index-1].firstname,Contact.all_contacts[index-1].lastname,Contact.all_contacts[index-1].email,Contact.all_contacts[index-1].address,
        Contact.all_contacts[index-1].tel]
        EDITCONTACTSTAPE.each.with_index do |stape, i|
            
            puts "#{stape} for (#{data[i]})"
            inf = gets.strip
            start if inf.upcase == "!Q"
            info << inf
        end
        while correct.empty?
            system "clear" or system "cls"
            info.each {|i| print "#{i} \t"}
            puts "\n","Is Everything correct? (Y/N)"
            correct = gets.strip.upcase
            if correct != "Y" && correct != "N" && correct != "YES" && correct != "NO"
                puts "\n", "Bad choice", "\n"
                correct = ""
            end
        end
        system "clear" or system "cls"
        if correct == "N" or correct == "NO"
            system "clear" or system "cls"
            edit_contact
        end
        puts Contact.edit_contact(index,info) if correct == "Y" or correct == "YES"
        puts "Choose an option:","\n"
        "show_option"
    end

    def self.delete_contact
        puts "Choose the contact to delete:","** You can type !q to back to the menu **"
        puts Contact.show_contacts_choosen,"\n"
        index = gets.strip
        if index.upcase == "!Q"
            save_contacts(Contact.to_json)
            return "start"
        end
        index = index.to_i
        if index < 1 or index > Contact.count_contacts
            system "cls" or system "clear"
            return "delete_contact"
        end
        puts "Are you sure? (Y/N)"
        ch = gets.strip.upcase
        if ch == "N" or ch == "NO"
            return "start"
        end
        system "clear" or system "cls"
        puts Contact.delete_contact(index)
        puts "\n","Choose an option:"
        "show_option"
    end

end