# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Admin reset password
# User.find(1).update(password: "123456")

# SUPER ADMIN
User.create(id: 8, firstname: "Super", lastname: "Admin", academic_college: 0, role: 2, email: "super_admin@tup.edu.ph", password: "123456", api_token: "6dbe948bb56f1d6827fbbd8321c7ad14", created_at: Time.now, updated_at: Time.now, status: 1)

# USERS
User.create(id: 1, firstname: "Aimee", middlename: "Guardaya", lastname: "Acoba", academic_college: 5, role: 0, email: "aimee_acoba@tup.edu.ph", password: "123456", api_token: "6dbe948bb56f1d6827fbbd8321c7ad14", created_at: Time.now, updated_at: Time.now, status: 1)
User.create(id: 2, firstname: "Marc Ardie", lastname: "Ardiente", academic_college: 1, role: 1, email: "marcardie_ardiente@tup.edu.ph", password: "123456", api_token: "6dbe948bb56f1d6827fbbd8321c7ad14", created_at: Time.now, updated_at: Time.now, status: 1)
User.create(id: 3, firstname: "Minabelle", lastname: "Villafurte", academic_college: 1, role: 1, email: "minabelle_villafuerte@tup.edu.ph", password: "123456", api_token: "6dbe948bb56f1d6827fbbd8321c7ad14", created_at: Time.now, updated_at: Time.now, status: 1)
User.create(id: 4, firstname: "Jonel", lastname: "Macalisang", academic_college: 1, role: 1, email: "jonel_macalisang@tup.edu.ph", password: "123456", api_token: "6dbe948bb56f1d6827fbbd8321c7ad14", created_at: Time.now, updated_at: Time.now, status: 1)
User.create(id: 5, firstname: "Hilda", lastname: "Robino", academic_college: 1, role: 1, email: "hilda_robino@tup.edu.ph", password: "123456", api_token: "6dbe948bb56f1d6827fbbd8321c7ad14", created_at: Time.now, updated_at: Time.now, status: 1)
User.create(id: 6, firstname: "Ian", lastname: "De Los Trinos", academic_college: 1, role: 1, email: "ian_delostrinos@tup.edu.ph", password: "123456", api_token: "6dbe948bb56f1d6827fbbd8321c7ad14", created_at: Time.now, updated_at: Time.now, status: 1)
User.create(id: 7, firstname: "Dennis", lastname: "Tabucol", academic_college: 1, role: 1, email: "dennis_tabucol@tup.edu.ph", password: "123456", api_token: "6dbe948bb56f1d6827fbbd8321c7ad14", created_at: Time.now, updated_at: Time.now, status: 1)

# CARDS
Card.create(id: 1, uid: "CARD001", status: 1, user_id: 1, uid_type: 0, remarks: nil, created_at: Time.now, updated_at: Time.now)
Card.create(id: 2, uid: "CARD002", status: 1, user_id: 2, uid_type: 0, remarks: nil, created_at: Time.now, updated_at: Time.now)
Card.create(id: 3, uid: "CARD003", status: 1, user_id: 3, uid_type: 0, remarks: nil, created_at: Time.now, updated_at: Time.now)
Card.create(id: 4, uid: "CARD004", status: 1, user_id: 4, uid_type: 0, remarks: nil, created_at: Time.now, updated_at: Time.now)
Card.create(id: 5, uid: "CARD005", status: 1, user_id: 5, uid_type: 0, remarks: nil, created_at: Time.now, updated_at: Time.now)
Card.create(id: 6, uid: "CARD006", status: 1, user_id: 6, uid_type: 0, remarks: nil, created_at: Time.now, updated_at: Time.now)
Card.create(id: 7, uid: "CARD007", status: 1, user_id: 7, uid_type: 0, remarks: nil, created_at: Time.now, updated_at: Time.now)
Card.create(id: 8, uid: "CARD008", status: 1, user_id: 8, uid_type: 0, remarks: nil, created_at: Time.now, updated_at: Time.now)
Card.create(id: 9, uid: "CARD009", status: 1, user_id: 9, uid_type: 0, remarks: nil, created_at: Time.now, updated_at: Time.now)

# ROOMS
Room.create(id: 1, room_number: 408, room_status: 1, remarks: nil, created_at: Time.now, updated_at: Time.now)
Room.create(id: 2, room_number: 409, room_status: 1, remarks: nil, created_at: Time.now, updated_at: Time.now)
Room.create(id: 3, room_number: 410, room_status: 0, remarks: nil, created_at: Time.now, updated_at: Time.now)
Room.create(id: 4, room_number: 411, room_status: 0, remarks: nil, created_at: Time.now, updated_at: Time.now)
Room.create(id: 5, room_number: 412, room_status: 0, remarks: nil, created_at: Time.now, updated_at: Time.now)

# SCHEDULES
# MARC ARDIE ARDIENTE
Schedule.create(id: 1, user_id: 2, description: 0, subject: "CPET2L-M", day: 2, start_time: "07:00", end_time: "10:00", room_id: 1, school_year: "2024-2025", semester: 1, year_level: 1, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 2, user_id: 2, description: 0, subject: "CPET2L-M", day: 4, start_time: "07:00", end_time: "10:00", room_id: 1, school_year: "2024-2025", semester: 1, year_level: 1, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 3, user_id: 2, description: 0, subject: "CPET9L-M", day: 5, start_time: "10:30", end_time: "13:30", room_id: 1, school_year: "2024-2025", semester: 1, year_level: 2, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 4, user_id: 2, description: 0, subject: "CPET15L-M", day: 1, start_time: "09:00", end_time: "12:00", room_id: 1, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 5, user_id: 2, description: 0, subject: "CPET15L-M", day: 1, start_time: "12:30", end_time: "15:30", room_id: 1, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 6, user_id: 2, description: 0, subject: "CPET15L-M", day: 2, start_time: "12:30", end_time: "15:30", room_id: 1, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 7, user_id: 2, description: 0, subject: "CPET15L-M", day: 4, start_time: "12:30", end_time: "15:30", room_id: 1, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 8, user_id: 2, description: 1, subject: "ELECTIVE2-M", day: 5, start_time: "07:00", end_time: "10:00", room_id: 1, school_year: "2024-2025", semester: 1, year_level: 4, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 9, user_id: 2, description: 1, subject: "ELECTIVE2-M", day: 5, start_time: "14:00", end_time: "17:00", room_id: 1, school_year: "2024-2025", semester: 1, year_level: 4, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 10, user_id: 2, description: 1, subject: "ELECTIVE2-M", day: 2, start_time: "10:30", end_time: "12:00", room_id: 1, school_year: "2024-2025", semester: 1, year_level: 4, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 11, user_id: 2, description: 1, subject: "ELECTIVE2-M", day: 4, start_time: "10:30", end_time: "12:00", room_id: 1, school_year: "2024-2025", semester: 1, year_level: 4, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 12, user_id: 2, description: 1, subject: "ELECTIVE2-M", day: 3, start_time: "09:00", end_time: "12:00", room_id: 1, school_year: "2024-2025", semester: 1, year_level: 4, remarks: nil, created_at: Time.now, updated_at: Time.now)

# MINABELLE VILLAFUERTE
Schedule.create(id: 13, user_id: 3, description: 0, subject: "CPET2L-M", day: 2, start_time: "07:00", end_time: "10:00", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 1, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 14, user_id: 3, description: 0, subject: "CPET2L-M", day: 2, start_time: "12:30", end_time: "15:30", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 1, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 15, user_id: 3, description: 0, subject: "CPET2L-M", day: 3, start_time: "07:00", end_time: "10:00", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 1, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 16, user_id: 3, description: 0, subject: "CPET2L-M", day: 3, start_time: "12:30", end_time: "15:30", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 1, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 17, user_id: 3, description: 0, subject: "CPTR1L-M", day: 5, start_time: "12:30", end_time: "15:30", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 1, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 18, user_id: 3, description: 0, subject: "CPTR1L-M", day: 1, start_time: "07:00", end_time: "10:00", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 1, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 19, user_id: 3, description: 1, subject: "CPET10-M", day: 1, start_time: "12:30", end_time: "15:30", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 2, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 20, user_id: 3, description: 1, subject: "CPET10-M", day: 4, start_time: "12:30", end_time: "15:30", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 2, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 21, user_id: 3, description: 1, subject: "CPET8-M", day: 2, start_time: "10:30", end_time: "12:00", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 2, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 22, user_id: 3, description: 1, subject: "CPET8-M", day: 4, start_time: "10:30", end_time: "12:00", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 2, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 23, user_id: 3, description: 1, subject: "BET3-M", day: 2, start_time: "07:00", end_time: "10:00", room_id: 4, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 24, user_id: 3, description: 1, subject: "BET3-M", day: 3, start_time: "10:30", end_time: "12:00", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 25, user_id: 3, description: 1, subject: "BET3-M", day: 5, start_time: "10:30", end_time: "12:00", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 26, user_id: 3, description: 1, subject: "ELECTIVE1-M", day: 4, start_time: "07:00", end_time: "10:00", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 27, user_id: 3, description: 1, subject: "ELECTIVE1-M", day: 5, start_time: "07:00", end_time: "10:00", room_id: 2, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)

# JONEL MACALISANG
Schedule.create(id: 28, user_id: 4, description: 1, subject: "CAD-M", day: 1, start_time: "10:30", end_time: "13:30", room_id: 3, school_year: "2024-2025", semester: 1, year_level: 1, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 29, user_id: 4, description: 1, subject: "CAD-M", day: 3, start_time: "10:30", end_time: "13:30", room_id: 3, school_year: "2024-2025", semester: 1, year_level: 1, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 30, user_id: 4, description: 1, subject: "CpET14-M", day: 5, start_time: "12:30", end_time: "15:30", room_id: 3, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 31, user_id: 4, description: 1, subject: "CpET14-M", day: 2, start_time: "10:30", end_time: "12:00", room_id: 3, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 32, user_id: 4, description: 1, subject: "CpET14-M", day: 4, start_time: "10:30", end_time: "12:00", room_id: 3, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 33, user_id: 4, description: 0, subject: "CpET14L-M", day: 2, start_time: "12:30", end_time: "15:30", room_id: 3, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 34, user_id: 4, description: 0, subject: "CpET14L-M", day: 4, start_time: "12:30", end_time: "15:30", room_id: 3, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 35, user_id: 4, description: 0, subject: "CpET14L-M", day: 2, start_time: "16:00", end_time: "19:00", room_id: 3, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 36, user_id: 4, description: 0, subject: "CpET14L-M", day: 4, start_time: "16:00", end_time: "19:00", room_id: 3, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 37, user_id: 4, description: 0, subject: "CpET14L-M", day: 1, start_time: "16:00", end_time: "19:00", room_id: 3, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
Schedule.create(id: 38, user_id: 4, description: 0, subject: "CpET14L-M", day: 3, start_time: "16:00", end_time: "19:00", room_id: 3, school_year: "2024-2025", semester: 1, year_level: 3, remarks: nil, created_at: Time.now, updated_at: Time.now)
