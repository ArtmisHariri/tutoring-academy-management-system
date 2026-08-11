-- استفاده از پایگاه داده testdb
USE testdb;
-------------------------------------------------------------------------------------------------------------------------------
--ساخت جداول
-------------------------------------------------------------------------------------------------------------------------------
-- ایجاد جدول دانش‌آموزان با اطلاعات شناسایی، تحصیلی و تماس
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    father_name VARCHAR(100) NOT NULL,
    national_id CHAR(10) UNIQUE NOT NULL,
    birth_date DATE,
    grade ENUM('دهم', 'یازدهم', 'دوازدهم', 'فارغ‌التحصیل') NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- ایجاد جدول حساب‌های کاربری دانش‌آموزان با نگهداری نام کاربری و رمز عبور هش شده
CREATE TABLE student_accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL UNIQUE,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    last_login DATETIME,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
-- ایجاد جدول معلمان با اطلاعات تماس و تخصص
CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    specialization VARCHAR(100)
);
-- ایجاد جدول دروس (موضوعات درسی) مانند ریاضی، فیزیک و ...
CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL UNIQUE
);
-- ایجاد جدول دوره‌ها که شامل اطلاعاتی درباره دوره، معلم، زمان‌بندی و قیمت است
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_title VARCHAR(100) NOT NULL,
    subject_id INT NOT NULL,
    teacher_id INT NOT NULL,
    start_date DATE,
    end_date DATE,
    capacity INT,
    course_type ENUM('حضوری', 'آنلاین') NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    class_days SET('شنبه','یکشنبه','دوشنبه','سه‌شنبه','چهارشنبه','پنجشنبه','جمعه'),
    class_time TIME,
    description TEXT,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- ایجاد جدول ثبت‌نام‌ها که ارتباط بین دانش‌آموز و دوره‌ها را نگه می‌دارد
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ثبت‌نام‌شده', 'انصراف‌داده', 'پایان‌یافته') DEFAULT 'ثبت‌نام‌شده',
    UNIQUE(student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
-- ایجاد جدول جلسات دوره‌ها با ثبت تاریخ، موضوع جلسه و وضعیت برگزاری
CREATE TABLE course_sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    session_date DATETIME NOT NULL,
    topic VARCHAR(255),
    status ENUM('برگزار‌شده', 'برگزار‌نشده', 'جبرانی') DEFAULT 'برگزار‌نشده',
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
-- ایجاد جدول حضور و غیاب دانش‌آموزان در جلسات دوره‌ها
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    student_id INT NOT NULL,
    status ENUM('حاضر', 'غایب', 'تاخیر') DEFAULT 'حاضر',
    UNIQUE(session_id, student_id),
    FOREIGN KEY (session_id) REFERENCES course_sessions(session_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
-- ایجاد جدول پرداختی‌ها شامل مبلغ، روش پرداخت و زمان پرداخت برای هر دانش‌آموز و دوره
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2),
    payment_method ENUM('نقدی', 'کارت', 'آنلاین'),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
-----------------------------------------------------------------------------------------------------------------------------
--درج اطلاعات
-----------------------------------------------------------------------------------------------------------------------------
-- درج نمونه‌ای از اطلاعات دانش‌آموزان
INSERT INTO students (full_name, father_name, national_id, birth_date, grade, phone, email)
VALUES
('زهرا احمدی', 'محمد', '0012345678', '2006-05-11', 'دوازدهم', '09121234567', 'zahra.ahmadi@mail.com'),
('علی رضایی', 'حسین', '0012345679', '2007-03-22', 'یازدهم', '09121234568', 'ali.rezaei@mail.com'),
('نگار صادقی', 'مهدی', '0012345680', '2005-11-15', 'فارغ‌التحصیل', '09121234569', 'negar.sadeghi@mail.com'),
('سارا کریمی', 'رضا', '0012345681', '2008-02-08', 'دهم', '09121234570', 'sara.karimi@mail.com'),
('آرین محمدی', 'اکبر', '0012345682', '2006-08-30', 'دوازدهم', '09121234571', 'arian.mohammadi@mail.com'),
('مهسا قاسمی', 'حسین', '0012345683', '2007-09-18', 'یازدهم', '09121234572', 'mahsa.ghasemi@mail.com'),
('رضا نوروزی', 'عباس', '0012345684', '2005-01-21', 'فارغ‌التحصیل', '09121234573', 'reza.norouzi@mail.com'),
('یاسمین ترابی', 'حمید', '0012345685', '2008-06-25', 'دهم', '09121234574', 'yasamin.torabi@mail.com');
-- درج اطلاعات حساب کاربری برای هر دانش‌آموز
INSERT INTO student_accounts (student_id, username, password_hash)
VALUES
(1, 'zahra_ahmadi', 'hashed_pass1'),
(2, 'ali_rezaei', 'hashed_pass2'),
(3, 'negar_sadeghi', 'hashed_pass3'),
(4, 'sara_karimi', 'hashed_pass4'),
(5, 'arian_mohammadi', 'hashed_pass5'),
(6, 'mahsa_ghasemi', 'hashed_pass6'),
(7, 'reza_norouzi', 'hashed_pass7'),
(8, 'yasamin_torabi', 'hashed_pass8');
-- درج اطلاعات معلمان
INSERT INTO teachers (full_name, phone, email, specialization)
VALUES
('دکتر نادری', '09120001111', 'nadery@mail.com', 'زیست‌شناسی'),
('مهندس طاهری', '09120002222', 'taheri@mail.com', 'ریاضی'),
('استاد مرادی', '09120003333', 'moradi@mail.com', 'شیمی'),
('خانم رضوانی', '09120004444', 'rezvani@mail.com', 'فیزیک'),
('دکتر آقایی', '09120005555', 'aghayi@mail.com', 'زمین‌شناسی'),
('آقای توکلی', '09120006666', 'tavakoli@mail.com', 'عربی'),
('خانم ابراهیمی', '09120007777', 'ebrahimi@mail.com', 'ادبیات فارسی'),
('استاد نوری', '09120008888', 'nouri@mail.com', 'دین و زندگی');
-- درج لیست موضوعات درسی
INSERT INTO subjects (subject_name)
VALUES
('زیست‌شناسی'),
('شیمی'),
('ریاضی'),
('فیزیک'),
('زمین‌شناسی'),
('عربی'),
('ادبیات فارسی'),
('دین و زندگی');
-- درج اطلاعات دوره‌های آموزشی مختلف
INSERT INTO courses (course_title, subject_id, teacher_id, start_date, end_date, capacity, course_type, price, class_days, class_time, description)
VALUES
('زیست دوازدهم', 1, 1, '2025-06-01', '2025-08-30', 30, 'حضوری', 2500000, 'شنبه,سه‌شنبه', '14:00:00', 'آموزش کامل زیست دوازدهم'),
('شیمی دهم', 2, 3, '2025-06-05', '2025-09-01', 25, 'آنلاین', 1800000, 'یکشنبه,چهارشنبه', '16:00:00', 'مفاهیم پایه شیمی'),
('ریاضی تجربی', 3, 2, '2025-06-03', '2025-09-10', 20, 'حضوری', 2200000, 'دوشنبه,پنجشنبه', '10:00:00', 'ریاضی مخصوص تجربی'),
('فیزیک یازدهم', 4, 4, '2025-06-02', '2025-08-28', 30, 'حضوری', 2100000, 'شنبه,دوشنبه', '12:00:00', 'فیزیک و مسائل محاسباتی'),
('زمین‌شناسی جامع', 5, 5, '2025-06-06', '2025-09-05', 15, 'آنلاین', 1600000, 'یکشنبه,سه‌شنبه', '17:00:00', 'جامع برای کنکور'),
('عربی کنکور', 6, 6, '2025-06-04', '2025-09-01', 25, 'آنلاین', 1400000, 'دوشنبه,پنجشنبه', '11:00:00', 'ترجمه، تحلیل و قواعد'),
('ادبیات فارسی کنکور', 7, 7, '2025-06-07', '2025-08-25', 20, 'حضوری', 1500000, 'شنبه,سه‌شنبه', '13:00:00', 'آرایه، قرابت، دستور'),
('دین و زندگی دهم', 8, 8, '2025-06-01', '2025-09-01', 20, 'آنلاین', 1300000, 'یکشنبه,چهارشنبه', '15:00:00', 'درس‌نامه + تست');
-- ثبت‌نام دانش‌آموزان در دوره‌ها با وضعیت ثبت‌نامی مشخص
INSERT INTO enrollments (student_id, course_id, status)
VALUES
(1, 1, 'ثبت‌نام‌شده'),
(2, 2, 'ثبت‌نام‌شده'),
(3, 3, 'پایان‌یافته'),
(4, 4, 'ثبت‌نام‌شده'),
(5, 5, 'انصراف‌داده'),
(6, 6, 'ثبت‌نام‌شده'),
(7, 7, 'پایان‌یافته'),
(8, 8, 'ثبت‌نام‌شده');
-- درج جلسات مربوط به هر دوره با اطلاعات تاریخ و موضوع جلسه
INSERT INTO course_sessions (course_id, session_date, topic, status)
VALUES
(1, '2025-06-01 14:00:00', 'مقدمه سلول', 'برگزار‌شده'),
(2, '2025-06-05 16:00:00', 'مواد و خواص آن‌ها', 'برگزار‌شده'),
(3, '2025-06-03 10:00:00', 'مقدمه معادله', 'برگزار‌شده'),
(4, '2025-06-02 12:00:00', 'حرکت یکنواخت', 'برگزار‌شده'),
(5, '2025-06-06 17:00:00', 'ساختار زمین', 'برگزار‌نشده'),
(6, '2025-06-04 11:00:00', 'تحلیل متن عربی', 'برگزار‌شده'),
(7, '2025-06-07 13:00:00', 'آرایه‌های ادبی', 'برگزار‌شده'),
(8, '2025-06-01 15:00:00', 'درس اول دین و زندگی', 'برگزار‌شده');
-- ثبت حضور و غیاب دانش‌آموزان در جلسات
INSERT INTO attendance (session_id, student_id, status)
VALUES
(1, 1, 'حاضر'),
(2, 2, 'حاضر'),
(3, 3, 'تاخیر'),
(4, 4, 'حاضر'),
(5, 5, 'غایب'),
(6, 6, 'حاضر'),
(7, 7, 'حاضر'),
(8, 8, 'تاخیر');
-- ثبت پرداخت‌های انجام شده برای دوره‌ها توسط دانش‌آموزان
INSERT INTO payments (student_id, course_id, amount, payment_method)
VALUES
(1, 1, 2500000, 'کارت'),
(2, 2, 1800000, 'آنلاین'),
(3, 3, 2200000, 'نقدی'),
(4, 4, 2100000, 'کارت'),
(5, 5, 1600000, 'آنلاین'),
(6, 6, 1400000, 'کارت'),
(7, 7, 1500000, 'نقدی'),
(8, 8, 1300000, 'آنلاین');
-------------------------------------------------------------------------------------------------------------------------------
--ویوها
-------------------------------------------------------------------------------------------------------------------------------
-- ایجاد نمایی برای نمایش خلاصه‌ای از پرداختی‌های دانش‌آموزان
CREATE VIEW student_payment_summary AS
SELECT 
    s.student_id,
    s.full_name,
    COUNT(p.payment_id) AS payment_count,
    SUM(p.amount) AS total_paid,
    GROUP_CONCAT(DISTINCT p.payment_method SEPARATOR ', ') AS payment_methods
FROM 
    students s
JOIN 
    payments p ON s.student_id = p.student_id
GROUP BY 
    s.student_id, s.full_name;
-- مشاهده اطلاعات از نمای student_payment_summary
    SELECT * FROM student_payment_summary;

-- ایجاد نمایی برای نمایش آمار حضور و غیاب دانش‌آموزان
 CREATE VIEW student_attendance_report AS
SELECT 
    s.student_id,
    s.full_name,
    COUNT(a.attendance_id) AS total_sessions,
    SUM(a.status = 'حاضر') AS present_count,
    SUM(a.status = 'غایب') AS absent_count,
    SUM(a.status = 'تاخیر') AS late_count
FROM 
    students s
LEFT JOIN 
    attendance a ON s.student_id = a.student_id
GROUP BY 
    s.student_id, s.full_name;
-- مشاهده اطلاعات از نمای student_attendance_report
    SELECT * FROM student_attendance_report;
-- ایجاد نمایی از ثبت‌نام‌های فعال (در حال حاضر ثبت‌نام‌شده)
CREATE VIEW active_enrollments_view AS
SELECT 
    e.enrollment_id,
    s.full_name AS student_name,
    c.course_title,
    t.full_name AS teacher_name,
    c.start_date,
    c.end_date,
    e.status
FROM 
    enrollments e
JOIN 
    students s ON e.student_id = s.student_id
JOIN 
    courses c ON e.course_id = c.course_id
JOIN 
    teachers t ON c.teacher_id = t.teacher_id
WHERE 
    e.status = 'ثبت‌نام‌شده';
-- مشاهده اطلاعات از نمای active_enrollments_view    
    SELECT * FROM active_enrollments_view;
-- ایجاد نمایی برای نمایش خلاصه‌ای از جلسات برگزار شده هر دوره
CREATE VIEW course_sessions_summary AS
SELECT 
    c.course_id,
    c.course_title,
    COUNT(cs.session_id) AS total_sessions,
    SUM(cs.status = 'برگزار‌شده') AS held_sessions,
    SUM(cs.status = 'برگزار‌نشده') AS missed_sessions,
    SUM(cs.status = 'جبرانی') AS compensatory_sessions
FROM 
    courses c
LEFT JOIN 
    course_sessions cs ON c.course_id = cs.course_id
GROUP BY 
    c.course_id, c.course_title;
-- مشاهده جزئیات جلسات دوره‌ها
    SELECT *  FROM course_sessions;
-- ایجاد نمایی برای محاسبه درآمد حاصل از هر دوره
    CREATE VIEW course_revenue_report AS
SELECT 
    c.course_id,
    c.course_title,
    COUNT(p.payment_id) AS num_payments,
    SUM(p.amount) AS total_revenue
FROM 
    courses c
JOIN 
    payments p ON c.course_id = p.course_id
GROUP BY 
    c.course_id, c.course_title;
-- مشاهده اطلاعات نمای درآمد دوره‌ها
    SELECT * FROM course_revenue_report;
-----------------------------------------------------------------------------------------------------------------------
--stored procedure
-----------------------------------------------------------------------------------------------------------------------
--هدف
CALL get_student_report(IN student_id INT);
--کد stored procedure
DELIMITER //

CREATE PROCEDURE get_student_report(IN in_student_id INT)
BEGIN
    -- مشخصات دانش‌آموز
    SELECT 
        s.full_name,
        s.national_id,
        s.grade,
        s.email,
        s.phone,
        s.registration_date
    FROM students s
    WHERE s.student_id = in_student_id;

    -- آمار ثبت‌نام‌ها
    SELECT 
        SUM(e.status = 'ثبت‌نام‌شده') AS active_enrollments,
        SUM(e.status = 'انصراف‌داده') AS withdrawn_enrollments,
        SUM(e.status = 'پایان‌یافته') AS completed_enrollments
    FROM enrollments e
    WHERE e.student_id = in_student_id;

    -- جمع کل پرداخت‌ها
    SELECT 
        COUNT(p.payment_id) AS total_payments,
        SUM(p.amount) AS total_paid,
        GROUP_CONCAT(DISTINCT p.payment_method SEPARATOR ', ') AS payment_methods
    FROM payments p
    WHERE p.student_id = in_student_id;

    -- آمار حضور و غیاب
    SELECT 
        COUNT(a.attendance_id) AS total_attendances,
        SUM(a.status = 'حاضر') AS present_count,
        SUM(a.status = 'غایب') AS absent_count,
        SUM(a.status = 'تاخیر') AS late_count
    FROM attendance a
    WHERE a.student_id = in_student_id;

    -- لیست دوره‌های فعال فعلی دانش‌آموز
    SELECT 
        c.course_title,
        c.start_date,
        c.end_date,
        t.full_name AS teacher_name
    FROM enrollments e
    JOIN courses c ON e.course_id = c.course_id
    JOIN teachers t ON c.teacher_id = t.teacher_id
    WHERE e.student_id = in_student_id AND e.status = 'ثبت‌نام‌شده';
    
END //

DELIMITER ;
--اجرا
CALL get_student_report(1); 
-----------------------------------------------------------------------------------------------------------------------
--تریگر
-----------------------------------------------------------------------------------------------------------------------
-- ایجاد جدول لاگ پرداخت‌ها برای ثبت تغییرات پرداخت‌ها به صورت خودکار
CREATE TABLE payment_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT,
    student_id INT,
    course_id INT,
    amount DECIMAL(10,2),
    payment_method ENUM('نقدی', 'کارت', 'آنلاین'),
    logged_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- تعریف تریگر برای ثبت اطلاعات پرداخت در جدول لاگ بلافاصله پس از درج پرداخت
DELIMITER $$

CREATE TRIGGER after_payment_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    INSERT INTO payment_logs (payment_id, student_id, course_id, amount, payment_method)
    VALUES (NEW.payment_id, NEW.student_id, NEW.course_id, NEW.amount, NEW.payment_method);
END$$

DELIMITER ;
-- درج اطلاعات تستی برای بررسی عملکرد ساختار
INSERT INTO students (full_name, father_name, national_id, birth_date, grade)
VALUES ('تست دانشجو', 'پدر تستی', '1234567890', '2000-01-01', 'دهم');
INSERT INTO subjects (subject_name)
VALUES ('زیست');
INSERT INTO teachers (full_name)
VALUES ('معلم تستی');
INSERT INTO courses (course_title, subject_id, teacher_id, course_type, price)
VALUES ('دوره تستی', 1, 1, 'حضوری', 150000);

INSERT INTO payments (student_id, course_id, amount, payment_method)
VALUES (1, 1, 150000, 'نقدی');
-- بررسی لاگ‌های پرداخت پس از اجرای تریگر
SELECT * FROM payment_logs;
----------------------------------------------------------------------------------------------------------------------------------
--کوئری ها
----------------------------------------------------------------------------------------------------------------------------------
-- نمایش دانش‌آموزانی که در حال حاضر حداقل در یک دوره ثبت‌نام شده‌اند
SELECT 
    s.student_id,
    s.full_name,
    COUNT(e.course_id) AS active_courses
FROM 
    students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE 
    e.status = 'ثبت‌نام‌شده'
GROUP BY 
    s.student_id, s.full_name
HAVING 
    COUNT(e.course_id) >= 1;

-- نمایش گران‌ترین پرداخت هر دانش‌آموز برای یک دوره خاص
SELECT 
    s.full_name,
    c.course_title,
    p.amount
FROM 
    payments p
JOIN students s ON p.student_id = s.student_id
JOIN courses c ON p.course_id = c.course_id
WHERE 
    p.amount = (
        SELECT MAX(p2.amount)
        FROM payments p2
        WHERE p2.student_id = p.student_id
    );
    
 -- نمایش دانش‌آموزانی که در تمامی جلسات ثبت‌شده خود حاضر بوده‌اند
    SELECT 
    s.full_name,
    COUNT(a.attendance_id) AS total_sessions,
    SUM(a.status = 'حاضر') AS present_sessions
FROM 
    students s
JOIN attendance a ON s.student_id = a.student_id
GROUP BY 
    s.student_id
HAVING 
    COUNT(a.attendance_id) = SUM(a.status = 'حاضر');

-- نمایش دوره‌هایی که درآمدشان بیشتر از میانگین درآمد سایر دوره‌ها است
SELECT 
    c.course_title,
    SUM(p.amount) AS course_revenue
FROM 
    courses c
JOIN payments p ON c.course_id = p.course_id
GROUP BY 
    c.course_id, c.course_title
HAVING 
    SUM(p.amount) > (
        SELECT AVG(total)
        FROM (
            SELECT SUM(p2.amount) AS total
            FROM payments p2
            GROUP BY p2.course_id
        ) AS avg_table
    );
    
-- نمایش گزارش کلی از فعالیت دانش‌آموزان شامل تعداد دوره، جلسات، حضور و مجموع پرداختی‌ها    
SELECT 
    s.full_name,
    COUNT(DISTINCT e.course_id) AS total_courses,
    COUNT(DISTINCT a.attendance_id) AS total_attendance,
    SUM(a.status = 'حاضر') AS present_count,
    (SELECT SUM(p.amount) FROM payments p WHERE p.student_id = s.student_id) AS total_payment
FROM 
    students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY 
    s.student_id, s.full_name;
