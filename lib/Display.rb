require '../lib/Contact'
require 'terminal-table'

class Display
    FILENAME = "contact.json"
    ADDCONTACTSTAPE = ["Enter the firstname","Enter the lastname","Enter the email","Enter the address","Enter the phone number"]
    EDITCONTACTSTAPE = ["Enter the new firstname","Enter the new lastname","Enter the new email","Enter the new address","Enter the new phone number"]

    def self.load_contacts
        json_contacts = ""
        json_contacts = File.read("../#{FILENAME}") if File.exists?("../#{FILENAME}")
        json_contacts
    end
    
    def self.save_contacts(json_contacts)
        File.open("../#{FILENAME}","w+") do |f|
            f.write(json_contacts)
        end
    end

    def self.start
        system "clear" or system "cls"
        puts "Welcome to My_Contact"
        json_contacts = self.load_contacts
        Contact.add_all_contacts json_contacts
        puts "You have #{Contact.count_contacts} contact(s)","** You can type !q to back to the menu **"
        puts "-----------------------------------------------","Choose an option:"
        self.show_option
    end

    def self.show_option
        puts "1. Add a contact", "2. Show contacts asc", "3. Show contacts desc", "4. Edit a contact", "5. Delete a contact", "6. Exit to My_contact", "\n"
        
        option = gets.strip.to_i
        if option < 0 || option > 6
            system "clear" or system "cls"
            puts "\n","Option out of range", "Please choose an option:","\n"
            self.show_option
        end

        case option
        when 1
            system "clear" or system "cls"
            self.add_contact
        when 2, 3
            system "clear" or system "cls"
            if Contact.count_contacts == 0
                puts " You have no contact to see yet","\n","Choose an option:"
                self.show_option
            end
            row_header = ["No", "Fullname","Email","Address","Phone number"]
            row_table = Contact.show_all_contacts if option == 2
            row_table = Contact.show_all_contacts("desc") if option == 3
            table = Terminal::Table.new :headings => row_header, :rows => row_table
            puts table
            puts "\n","Choose an option:"
            self.show_option
        when 4
            if Contact.count_contacts == 0
                system "clear" or system "cls"
                puts " You have no contact to edit yet","\n","Choose an option:"
                self.show_option
            end
            self.edit_contact
        when 5
            self.delete_contact
        when 0, 6
            puts "Byeeeeeee"
            self.save_contacts(Contact.to_json)
            exit
        end
    end
    
    def self.add_contact
        info, correct = [], ""
        ADDCONTACTSTAPE.each do |stape|
            puts "\n",stape
            inf = gets.strip
            if inf.upcase == "!Q"
                self.save_contacts(Contact.to_json)
                self.start
            end
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
        self.add_contact if correct == "N" or correct == "NO"
        puts Contact.add_contact(info) if correct == "Y" or correct == "YES"
        puts "Now you have #{Contact.count_contacts} contact(s)","Choose an option:","\n"
        self.show_option
    end

    def self.edit_contact
        info, correct = [], ""
        system "clear" or system "cls"
        puts "Choose the contact to edite:","** You can type !q to back to the menu **",Contact.show_contacts_choosen,"\n"
        index = gets.strip
        if index.upcase == "!Q"
            self.save_contacts(Contact.to_json)
            self.start
        end
        index = index.to_i
        if index < 1 or index > (Contact.count_contacts)
            self.edit_contact
        end
        EDITCONTACTSTAPE.each do |stape|
            puts stape
            inf = gets.strip
            self.start if inf.upcase == "!Q"
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
        self.edit_contact if correct == "N" or correct == "NO"
        puts Contact.edit_contact(index,info) if correct == "Y" or correct == "YES"
        puts "Choose an option:","\n"
        self.show_option
    end

    def self.delete_contact
        system "clear" or system "cls"
        if Contact.count_contacts == 0
            puts " You have no contact to delete yet","\n","Choose an option:"
            self.show_option
        end
        puts "Choose the contact to delete:","** You can type !q to back to the menu **"
        puts Contact.show_contacts_choosen,"\n"
        opt = gets.strip
        if opt.upcase == "!Q"
            self.save_contacts(Contact.to_json)
            self.start
        end
        opt = opt.to_i
        if opt < 1 or opt > Contact.count_contacts
            self.delete_contact
        end
        system "clear" or system "cls"
        puts Contact.delete_contact(opt)
        puts "\n","Choose an option:"
        self.show_option
    end

end