#  Tutoring / Academy Management System (MySQL)

سیستم مدیریت آموزشگاه کنکور — یک پروژه پایگاه‌داده‌ی MySQL برای مدیریت دانش‌آموزان، معلمان، دوره‌های آموزشی، ثبت‌نام، حضور و غیاب و پرداخت‌ها.

##  درباره پروژه

این پروژه یک طراحی کامل از پایگاه‌داده برای یک موسسه آموزشی/کنکوری است که شامل:

- مدیریت اطلاعات دانش‌آموزان و حساب‌های کاربری آن‌ها
- مدیریت معلمان، دروس و دوره‌های آموزشی (حضوری/آنلاین)
- ثبت‌نام دانش‌آموزان در دوره‌ها و پیگیری وضعیت آن‌ها
- برگزاری جلسات و ثبت حضور و غیاب
- ثبت و گزارش‌گیری از پرداخت‌های شهریه
- گزارش‌گیری خودکار با View، Stored Procedure و Trigger

##ساختار جدول‌ها (Schema)

| جدول | توضیح |
|---|---|
| `students` | اطلاعات هویتی و تحصیلی دانش‌آموزان |
| `student_accounts` | حساب کاربری دانش‌آموزان (نام کاربری و رمز هش‌شده) |
| `teachers` | اطلاعات معلمان و تخصص هر یک |
| `subjects` | موضوعات درسی |
| `courses` | دوره‌های آموزشی (زمان، ظرفیت، قیمت، نوع برگزاری) |
| `enrollments` | ثبت‌نام دانش‌آموز در دوره و وضعیت آن |
| `course_sessions` | جلسات هر دوره و وضعیت برگزاری |
| `attendance` | حضور و غیاب دانش‌آموزان در جلسات |
| `payments` | پرداخت‌های شهریه دانش‌آموزان |
| `payment_logs` | لاگ خودکار پرداخت‌ها (توسط Trigger) |

### دیاگرام روابط (ساده‌شده)

```
students ──< student_accounts
students ──< enrollments >── courses >── subjects
students ──< attendance >── course_sessions >── courses >── teachers
students ──< payments >── courses
payments ──> payment_logs (via trigger)
```

##  View های موجود

| View | کاربرد |
|---|---|
| `student_payment_summary` | خلاصه پرداخت‌های هر دانش‌آموز |
| `student_attendance_report` | آمار حضور، غیاب و تأخیر هر دانش‌آموز |
| `active_enrollments_view` | ثبت‌نام‌های فعال به همراه اطلاعات دوره و معلم |
| `course_sessions_summary` | خلاصه وضعیت جلسات هر دوره |
| `course_revenue_report` | گزارش درآمد هر دوره |

##  Stored Procedure

```sql
CALL get_student_report(student_id);
```
گزارش جامع یک دانش‌آموز شامل مشخصات، آمار ثبت‌نام، مجموع پرداخت‌ها، آمار حضور و غیاب و دوره‌های فعال فعلی را در چند نتیجه (result set) برمی‌گرداند.

> ⚠️ نکته: در فایل اصلی خطی به‌شکل `CALL get_student_report(IN student_id INT);` به‌عنوان توضیح هدف نوشته شده که syntax معتبری نیست و پیش از اجرا باید حذف یا کامنت شود؛ فراخوانی صحیح همان `CALL get_student_report(1);` است.

##  Trigger

`after_payment_insert` — با هر بار ثبت یک پرداخت جدید، به‌صورت خودکار یک رکورد در جدول `payment_logs` ثبت می‌کند.

## کوئری‌های تحلیلی نمونه

فایل شامل چند کوئری تحلیلی آماده است، از جمله:
- دانش‌آموزانی که حداقل در یک دوره ثبت‌نام فعال دارند
- گران‌ترین پرداخت هر دانش‌آموز
- دانش‌آموزانی که در تمام جلسات خود حاضر بوده‌اند
- دوره‌هایی که درآمدشان بالاتر از میانگین است
- گزارش کلی فعالیت هر دانش‌آموز (دوره، حضور، پرداخت)

## نحوه اجرا

```bash
mysql -u root -p
CREATE DATABASE testdb;
USE testdb;
SOURCE courses_sql.sql;
```

یا از طریق MySQL Workbench / phpMyAdmin فایل `courses_sql.sql` را روی یک دیتابیس جدید اجرا کنید.

##تکنولوژی

- **MySQL** (سازگار با نسخه‌های 5.7 به بالا)
- شامل: `CREATE TABLE`, `FOREIGN KEY`, `ENUM`, `SET`, `VIEW`, `STORED PROCEDURE`, `TRIGGER`


