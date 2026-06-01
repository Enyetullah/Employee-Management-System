/*
Employee Management System Database Project
Author: Enyetullah Rahimullah
Database: PostgreSQL

Project purpose:
This project builds a PostgreSQL employee management database for tracking
employees, organizations, job roles, employee types, contact records, and work
assignments.
*/

-- ============================================================
-- 1. SCHEMA SETUP
-- ============================================================

DROP SCHEMA IF EXISTS employee_management_system CASCADE;
CREATE SCHEMA employee_management_system;
SET search_path TO employee_management_system;

-- ============================================================
-- 2. TABLE CREATION
-- ============================================================

-- Stores address categories used by employee contact records.
CREATE TABLE address_type (
    address_type_id INTEGER PRIMARY KEY,
    address_type_name VARCHAR(30) NOT NULL UNIQUE,
    address_type_description TEXT NOT NULL
);

-- Stores job roles such as Engineer, Product Manager, Sales, and DBA Specialist.
CREATE TABLE employee_role (
    employee_role_id INTEGER PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    role_description TEXT NOT NULL
);

-- Stores employee classifications and compensation-related metadata.
CREATE TABLE employee_type (
    employee_type_id INTEGER PRIMARY KEY,
    employee_type_name VARCHAR(80) NOT NULL UNIQUE,
    employee_type_description TEXT NOT NULL,
    pay_frequency VARCHAR(20) NOT NULL,
    benefit_rate NUMERIC(5,2) NOT NULL,
    CONSTRAINT chk_employee_type_pay_frequency
        CHECK (pay_frequency IN ('Hourly', 'Bi-Weekly', 'Monthly')),
    CONSTRAINT chk_employee_type_benefit_rate
        CHECK (benefit_rate >= 0)
);

-- Stores organizations or client business units where employees are assigned.
CREATE TABLE organization (
    organization_id INTEGER PRIMARY KEY,
    organization_name VARCHAR(80) NOT NULL,
    organization_code INTEGER NOT NULL,
    business_domain VARCHAR(80) NOT NULL,
    availability_date DATE NOT NULL,
    organization_level VARCHAR(20) NOT NULL,
    country_code CHAR(2) NOT NULL
);

-- Stores employee contact and profile information.
-- This table intentionally avoids sensitive fields that are not needed for this project.
CREATE TABLE person (
    person_id INTEGER PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    middle_name VARCHAR(40),
    last_name VARCHAR(40) NOT NULL,
    age INTEGER NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(120) NOT NULL UNIQUE,
    address_type_id INTEGER NOT NULL,
    device_type VARCHAR(30),
    CONSTRAINT chk_person_age
        CHECK (age BETWEEN 18 AND 75),
    CONSTRAINT fk_person_address_type
        FOREIGN KEY (address_type_id)
        REFERENCES address_type(address_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Stores employee work assignments and connects people to roles, types, and organizations.
CREATE TABLE employee (
    employee_id INTEGER PRIMARY KEY,
    employee_role_id INTEGER NOT NULL,
    employee_type_id INTEGER NOT NULL,
    organization_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL UNIQUE,
    home_country VARCHAR(60) NOT NULL,
    work_country VARCHAR(60) NOT NULL,
    employment_status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT chk_employee_status
        CHECK (employment_status IN ('Active', 'On Leave', 'Inactive')),
    CONSTRAINT fk_employee_role
        FOREIGN KEY (employee_role_id)
        REFERENCES employee_role(employee_role_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_employee_type
        FOREIGN KEY (employee_type_id)
        REFERENCES employee_type(employee_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_employee_organization
        FOREIGN KEY (organization_id)
        REFERENCES organization(organization_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_employee_person
        FOREIGN KEY (person_id)
        REFERENCES person(person_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- ============================================================
-- 3. DATA INSERTION
-- ============================================================

INSERT INTO address_type (address_type_id, address_type_name, address_type_description) VALUES
    (1, 'Home', 'Residential address used for employee contact records.'),
    (2, 'Business', 'Business address used for workplace or client communication.'),
    (3, 'Emergency', 'Emergency contact address used when quick communication is needed.'),
    (4, 'Mailing', 'Mailing address used for documents and official notices.');

INSERT INTO employee_role (employee_role_id, role_name, role_description) VALUES
    (1, 'CEO', 'Provides executive leadership and organization-wide strategic direction.'),
    (2, 'CTO', 'Leads technology strategy, technical architecture, and engineering direction.'),
    (3, 'DBA Specialist', 'Maintains database reliability, access control, backups, and performance.'),
    (4, 'DevOps', 'Supports deployment pipelines, infrastructure automation, and system reliability.'),
    (5, 'Engineer', 'Designs, builds, tests, and maintains technical systems and internal tools.'),
    (6, 'HR', 'Supports hiring, employee relations, onboarding, and workplace processes.'),
    (7, 'Manager', 'Coordinates team operations, planning, communication, and delivery.'),
    (8, 'Marketing Head', 'Leads marketing strategy, campaign planning, and brand communication.'),
    (9, 'Product Manager', 'Leads product planning, stakeholder communication, and delivery priorities.'),
    (10, 'QA Tester', 'Tests software quality, documents defects, and supports release readiness.'),
    (11, 'QA Lead', 'Leads quality assurance planning, testing standards, and QA team coordination.'),
    (12, 'Receptionist', 'Supports front-desk operations, visitor communication, and office coordination.'),
    (13, 'Sales', 'Supports customer relationships, sales operations, and revenue-focused outreach.');

INSERT INTO employee_type (employee_type_id, employee_type_name, employee_type_description, pay_frequency, benefit_rate) VALUES
    (1, 'Accounting', 'Employee group focused on financial records, budgets, and reporting.', 'Monthly', 0.03),
    (2, 'Business Development', 'Employee group focused on partnerships, growth, and market expansion.', 'Monthly', 0.02),
    (3, 'Engineering', 'Employee group focused on software, systems, and technical delivery.', 'Bi-Weekly', 0.04),
    (4, 'Human Resources', 'Employee group focused on hiring, employee support, and workplace processes.', 'Monthly', 0.03),
    (5, 'Legal', 'Employee group focused on contracts, compliance, and legal operations.', 'Monthly', 0.03),
    (6, 'Marketing', 'Employee group focused on campaigns, brand communication, and market outreach.', 'Monthly', 0.02),
    (7, 'Product Management', 'Employee group focused on product planning, priorities, and stakeholder needs.', 'Monthly', 0.03),
    (8, 'Research and Development', 'Employee group focused on product research, prototyping, and improvement.', 'Monthly', 0.04),
    (9, 'Sales', 'Employee group focused on sales operations and client-facing work.', 'Bi-Weekly', 0.02),
    (10, 'Services', 'Employee group responsible for service delivery and internal operations.', 'Hourly', 0.03),
    (11, 'Support', 'Employee group focused on operational, technical, or customer support.', 'Hourly', 0.03),
    (12, 'Training', 'Employee group assigned to training and onboarding responsibilities.', 'Bi-Weekly', 0.03);

INSERT INTO organization (organization_id, organization_name, organization_code, business_domain, availability_date, organization_level, country_code) VALUES
    (1, 'Boeing Solutions', 3, 'Aerospace and Manufacturing', '2020-07-12', 'Level 4', 'CN'),
    (2, 'McDonald Enterprises', 4, 'Food Service and Operations', '2021-02-15', 'Level 2', 'UA'),
    (3, 'McDonald Enterprises', 3, 'Food Service and Operations', '2021-05-22', 'Level 2', 'BR'),
    (4, 'Macy''s Retail Group', 3, 'Retail and E-Commerce', '2019-06-13', 'Level 1', 'PT'),
    (5, 'Boeing Solutions', 2, 'Aerospace and Manufacturing', '2017-10-21', 'Level 3', 'FR'),
    (6, 'Chase Financial Group', 4, 'Banking and Financial Services', '2021-03-26', 'Level 4', 'DO'),
    (7, 'Boeing Solutions', 2, 'Aerospace and Manufacturing', '2017-08-28', 'Level 3', 'BR'),
    (8, 'Chase Financial Group', 2, 'Banking and Financial Services', '2021-12-21', 'Level 2', 'PH'),
    (9, 'McDonald Enterprises', 2, 'Food Service and Operations', '2020-03-01', 'Level 2', 'CN'),
    (10, 'Chase Financial Group', 3, 'Banking and Financial Services', '2021-08-05', 'Level 1', 'CN');

INSERT INTO person (person_id, first_name, middle_name, last_name, age, phone_number, email, address_type_id, device_type) VALUES
    (1, 'Bessy', 'Stillman', 'Maxfield', 53, '110 205 3647', 'smaxfield0@sohu.com', 4, 'iPad'),
    (2, 'Kinnie', 'Clemmie', 'Domsalla', 21, '447 716 7270', 'cdomsalla1@google.com', 2, 'Laptop'),
    (3, 'Idalina', 'Simone', 'Kopke', 36, '960 203 5645', 'skopke2@nifty.com', 4, 'iPad'),
    (4, 'Serene', 'Bryanty', 'Vowels', 42, '604 978 8061', 'bvowels3@clickbank.net', 3, 'Laptop'),
    (5, 'Keene', 'Barde', 'Careswell', 30, '639 532 9345', 'bcareswell4@pagesperso-orange.fr', 2, 'Phone'),
    (6, 'Darcee', 'Rocky', 'Scown', 33, '688 717 3188', 'rscown5@scribd.com', 2, 'Laptop'),
    (7, 'Vaughn', 'Eb', 'Manwaring', 29, '938 818 4917', 'emanwaring6@macromedia.com', 4, 'iPad'),
    (8, 'Stormi', 'Chaddie', 'Snead', 43, '170 481 4756', 'csnead7@state.gov', 4, 'Phone'),
    (9, 'Briana', 'Jeff', 'Jizhaki', 43, '488 973 4214', 'jjizhaki8@cafepress.com', 4, 'Phone'),
    (10, 'Dyann', 'Rudie', 'Windress', 40, '730 266 0008', 'rwindress9@taobao.com', 2, 'Laptop'),
    (11, 'Tuck', 'Hendrik', 'Forbear', 45, '224 546 7984', 'hforbeara@printfriendly.com', 3, 'Phone'),
    (12, 'Elissa', 'Curry', 'Attridge', 53, '924 582 8679', 'cattridgeb@cbsnews.com', 2, 'Laptop'),
    (13, 'Arie', 'Regan', 'Wase', 42, '982 501 8321', 'rwasec@phpbb.com', 4, 'Desktop'),
    (14, 'Freddy', 'Townsend', 'Duffell', 37, '835 953 5548', 'tduffelld@yellowpages.com', 2, 'Phone'),
    (15, 'Marrissa', 'Raynard', 'Tremblett', 53, '524 640 7332', 'rtremblette@lulu.com', 2, 'iPad'),
    (16, 'Katya', 'Brian', 'McMurraya', 43, '351 524 3668', 'bmcmurrayaf@seesaa.net', 4, 'Phone'),
    (17, 'Jody', 'Hubie', 'Chave', 48, '299 534 4095', 'hchaveg@macromedia.com', 4, 'Laptop'),
    (18, 'Kathie', 'Harp', 'Worwood', 40, '261 873 1813', 'hworwoodh@unc.edu', 3, 'Desktop'),
    (19, 'Torry', 'Raphael', 'Kaming', 46, '525 890 3683', 'rkamingi@lulu.com', 3, 'Phone'),
    (20, 'Maurice', 'Cord', 'Kilmurray', 49, '798 304 7049', 'ckilmurrayj@ocn.ne.jp', 2, 'iPad'),
    (21, 'Elinor', 'Adriano', 'Bartaletti', 32, '430 868 6515', 'abartalettik@google.nl', 4, 'Desktop'),
    (22, 'Paulina', 'Pace', 'Kleinert', 32, '773 875 3213', 'pkleinertl@craigslist.org', 2, 'Desktop'),
    (23, 'Norry', 'Shep', 'Dewitt', 28, '962 809 3315', 'sdewittm@gravatar.com', 4, 'iPad'),
    (24, 'Marie', 'Lek', 'Zanicchi', 45, '508 216 2172', 'lzanicchin@go.com', 3, 'Laptop'),
    (25, 'Shelagh', 'Rudolph', 'Cottel', 30, '383 121 4708', 'rcottelo@zdnet.com', 3, 'Desktop'),
    (26, 'Wenonah', 'Skippie', 'Tiler', 34, '661 293 3446', 'stilerp@nytimes.com', 4, 'Phone'),
    (27, 'Swen', 'Nikolos', 'Cawley', 26, '668 193 3533', 'ncawleyq@tiny.cc', 3, 'Laptop'),
    (28, 'Dene', 'Sig', 'Parkhouse', 43, '351 202 8071', 'sparkhouser@shareasale.com', 3, 'Laptop'),
    (29, 'Fara', 'Anatol', 'Reckhouse', 42, '209 820 3935', 'areckhouses@statcounter.com', 4, 'Laptop'),
    (30, 'Kerby', 'Pietro', 'Isaac', 34, '898 315 3130', 'pisaact@wordpress.com', 4, 'Desktop'),
    (31, 'Mavis', 'Tommy', 'Wildey', 36, '467 889 6731', 'twildeyu@buzzfeed.com', 2, 'Laptop'),
    (32, 'Charmane', 'Seth', 'Scowen', 54, '846 660 1753', 'sscowenv@sogou.com', 2, 'Laptop'),
    (33, 'Hanna', 'Johny', 'Hellyar', 50, '680 118 9395', 'jhellyarw@lulu.com', 2, 'Phone'),
    (34, 'Ferrell', 'Loren', 'Klesse', 23, '798 312 4778', 'lklessex@imgur.com', 2, 'Laptop'),
    (35, 'Arlette', 'Salomone', 'Cecchetelli', 49, '550 369 6637', 'scecchetelliy@smh.com.au', 3, 'Desktop'),
    (36, 'Petr', 'Clemens', 'Roseby', 50, '265 258 8308', 'crosebyz@networksolutions.com', 3, 'Desktop'),
    (37, 'Gayler', 'Nevin', 'Gisburn', 36, '124 809 5104', 'ngisburn10@taobao.com', 2, 'iPad'),
    (38, 'Cory', 'Brockie', 'Vicioso', 43, '701 992 3143', 'bvicioso11@pinterest.com', 2, 'Laptop'),
    (39, 'Joelynn', 'Cleve', 'Spinas', 29, '345 542 8958', 'cspinas12@themeforest.net', 4, 'iPad'),
    (40, 'Noel', 'Gayelord', 'Gooden', 41, '423 387 4381', 'ggooden13@lycos.com', 2, 'Laptop'),
    (41, 'Kennedy', 'Gasparo', 'Skittrell', 45, '669 438 1000', 'gskittrell14@seattletimes.com', 4, 'iPad'),
    (42, 'Ardelia', 'Nikolos', 'Drinkall', 48, '877 345 0551', 'ndrinkall15@va.gov', 4, 'Phone'),
    (43, 'Jesse', 'Silvio', 'Woollcott', 39, '254 418 9303', 'swoollcott16@clickbank.net', 4, 'Desktop'),
    (44, 'Jess', 'Les', 'Bottjer', 46, '982 920 2609', 'lbottjer17@linkedin.com', 2, 'Laptop'),
    (45, 'Ira', 'Lennie', 'Spridgen', 41, '662 974 5835', 'lspridgen18@gnu.org', 4, 'Phone'),
    (46, 'Westleigh', 'Edouard', 'Chuck', 45, '382 684 5030', 'echuck19@toplist.cz', 3, 'Laptop'),
    (47, 'Jacklin', 'Sander', 'Got', 46, '927 294 6358', 'sgot1a@issuu.com', 4, 'Laptop'),
    (48, 'Charlie', 'Bing', 'Jeeks', 54, '883 187 6978', 'bjeeks1b@dion.ne.jp', 2, 'iPad'),
    (49, 'Wadsworth', 'Wilbert', 'Pasterfield', 33, '158 767 9548', 'wpasterfield1c@un.org', 2, 'iPad'),
    (50, 'Kile', 'Gino', 'Dorkens', 46, '943 380 7721', 'gdorkens1d@addthis.com', 2, 'iPad');

INSERT INTO employee (employee_id, employee_role_id, employee_type_id, organization_id, person_id, home_country, work_country, employment_status) VALUES
    (1, 13, 10, 8, 1, 'Costa Rica', 'Denmark', 'Active'),
    (2, 4, 12, 10, 2, 'China', 'Costa Rica', 'Active'),
    (3, 5, 9, 2, 3, 'Portugal', 'Lithuania', 'Active'),
    (4, 7, 10, 10, 4, 'Mexico', 'Portugal', 'Active'),
    (5, 10, 2, 10, 5, 'China', 'Peru', 'Active'),
    (6, 10, 11, 3, 6, 'Poland', 'Indonesia', 'Active'),
    (7, 9, 3, 2, 7, 'Japan', 'France', 'On Leave'),
    (8, 11, 6, 6, 8, 'China', 'South Korea', 'Active'),
    (9, 5, 10, 9, 9, 'China', 'Finland', 'Active'),
    (10, 4, 1, 6, 10, 'Colombia', 'Ukraine', 'Inactive'),
    (11, 7, 10, 3, 11, 'Indonesia', 'Indonesia', 'Active'),
    (12, 6, 1, 6, 12, 'Indonesia', 'Russia', 'Active'),
    (13, 4, 6, 7, 13, 'China', 'Russia', 'Active'),
    (14, 2, 11, 4, 14, 'China', 'France', 'Active'),
    (15, 6, 1, 9, 15, 'Argentina', 'China', 'Active'),
    (16, 6, 1, 3, 16, 'China', 'Argentina', 'Active'),
    (17, 4, 11, 3, 17, 'China', 'China', 'On Leave'),
    (18, 12, 11, 6, 18, 'Haiti', 'Malta', 'Active'),
    (19, 8, 8, 3, 19, 'Russia', 'Thailand', 'Active'),
    (20, 11, 1, 8, 20, 'Indonesia', 'Peru', 'Inactive'),
    (21, 11, 12, 8, 21, 'Micronesia', 'Ethiopia', 'Active'),
    (22, 9, 12, 3, 22, 'Serbia', 'China', 'Active'),
    (23, 6, 12, 3, 23, 'Georgia', 'Philippines', 'Active'),
    (24, 8, 3, 8, 24, 'Yemen', 'French Guiana', 'Active'),
    (25, 7, 12, 3, 25, 'China', 'Indonesia', 'Active'),
    (26, 2, 1, 10, 26, 'Indonesia', 'China', 'Active'),
    (27, 10, 8, 4, 27, 'Indonesia', 'China', 'On Leave'),
    (28, 11, 9, 10, 28, 'Kazakhstan', 'Indonesia', 'Active'),
    (29, 9, 2, 5, 29, 'Indonesia', 'Yemen', 'Active'),
    (30, 7, 12, 8, 30, 'China', 'China', 'Inactive'),
    (31, 11, 11, 10, 31, 'Poland', 'Bolivia', 'Active'),
    (32, 10, 11, 8, 32, 'Serbia', 'Mexico', 'Active'),
    (33, 12, 10, 7, 33, 'Indonesia', 'Indonesia', 'Active'),
    (34, 12, 1, 5, 34, 'Philippines', 'Portugal', 'Active'),
    (35, 10, 1, 6, 35, 'China', 'Guatemala', 'Active'),
    (36, 5, 7, 7, 36, 'China', 'China', 'Active'),
    (37, 10, 11, 7, 37, 'Syria', 'Iran', 'On Leave'),
    (38, 7, 9, 3, 38, 'Indonesia', 'United States', 'Active'),
    (39, 5, 5, 8, 39, 'Canada', 'Argentina', 'Active'),
    (40, 11, 2, 4, 40, 'Czech Republic', 'China', 'Inactive'),
    (41, 13, 5, 9, 41, 'Indonesia', 'Uruguay', 'Active'),
    (42, 5, 1, 3, 42, 'China', 'Russia', 'Active'),
    (43, 4, 8, 2, 43, 'Indonesia', 'Colombia', 'Active'),
    (44, 10, 2, 10, 44, 'Poland', 'Indonesia', 'Active'),
    (45, 8, 5, 6, 45, 'China', 'Greece', 'Active'),
    (46, 5, 2, 10, 46, 'Germany', 'Indonesia', 'Active'),
    (47, 6, 4, 5, 47, 'China', 'South Africa', 'On Leave'),
    (48, 10, 2, 4, 48, 'Czech Republic', 'China', 'Active'),
    (49, 5, 1, 8, 49, 'Argentina', 'Armenia', 'Active'),
    (50, 7, 12, 4, 50, 'China', 'Poland', 'Inactive');


-- ============================================================
-- 4. VIEWS
-- ============================================================

-- Complete employee profile view used for reporting.
CREATE OR REPLACE VIEW employee_profile AS
SELECT
    e.employee_id,
    p.first_name || ' ' || p.last_name AS employee_name,
    p.email,
    p.phone_number,
    er.role_name,
    et.employee_type_name,
    et.pay_frequency,
    et.benefit_rate,
    o.organization_name,
    o.business_domain,
    o.organization_level,
    e.home_country,
    e.work_country,
    e.employment_status,
    p.device_type,
    addr.address_type_name
FROM employee AS e
JOIN person AS p
    ON e.person_id = p.person_id
JOIN employee_role AS er
    ON e.employee_role_id = er.employee_role_id
JOIN employee_type AS et
    ON e.employee_type_id = et.employee_type_id
JOIN organization AS o
    ON e.organization_id = o.organization_id
JOIN address_type AS addr
    ON p.address_type_id = addr.address_type_id;

-- Organization-level workforce summary view.
CREATE OR REPLACE VIEW organization_workforce_summary AS
SELECT
    o.organization_id,
    o.organization_name,
    o.business_domain,
    COUNT(e.employee_id) AS total_employees,
    COUNT(*) FILTER (WHERE e.employment_status = 'Active') AS active_employees,
    COUNT(*) FILTER (WHERE e.employment_status = 'On Leave') AS employees_on_leave,
    COUNT(*) FILTER (WHERE e.employment_status = 'Inactive') AS inactive_employees
FROM organization AS o
LEFT JOIN employee AS e
    ON o.organization_id = e.organization_id
GROUP BY o.organization_id, o.organization_name, o.business_domain;

-- ============================================================
-- 5. DATABASE CHECKS
-- ============================================================

-- PostgreSQL replacement for MySQL's SHOW TABLES.
SELECT
    table_name
FROM information_schema.tables
WHERE table_schema = 'employee_management_system'
ORDER BY table_name;

SELECT * FROM employee_profile ORDER BY employee_id;
SELECT * FROM organization_workforce_summary ORDER BY organization_name;

-- ============================================================
-- 6. PORTFOLIO-STYLE SQL QUERIES
-- ============================================================

-- 1. List all active employees with their role and organization.
SELECT
    employee_id,
    employee_name,
    role_name,
    organization_name,
    employment_status
FROM employee_profile
WHERE employment_status = 'Active'
ORDER BY organization_name, employee_name;

-- 2. Count employees by organization.
SELECT
    organization_name,
    business_domain,
    COUNT(*) AS employee_count
FROM employee_profile
GROUP BY organization_name, business_domain
ORDER BY employee_count DESC, organization_name;

-- 3. Count employees by job role.
SELECT
    role_name,
    COUNT(*) AS total_employees
FROM employee_profile
GROUP BY role_name
ORDER BY total_employees DESC, role_name;

-- 4. Show employee distribution by pay frequency.
SELECT
    pay_frequency,
    COUNT(*) AS total_employees,
    ROUND(AVG(benefit_rate), 2) AS average_benefit_rate
FROM employee_profile
GROUP BY pay_frequency
ORDER BY total_employees DESC;

-- 5. Find employees working outside their home country.
SELECT
    employee_id,
    employee_name,
    home_country,
    work_country,
    organization_name
FROM employee_profile
WHERE home_country <> work_country
ORDER BY employee_name;

-- 6. Device usage summary for employee records.
SELECT
    device_type,
    COUNT(*) AS total_users
FROM employee_profile
GROUP BY device_type
ORDER BY total_users DESC, device_type;

-- 7. Organizations with more than five employees.
SELECT
    organization_name,
    total_employees
FROM organization_workforce_summary
WHERE total_employees > 5
ORDER BY total_employees DESC;

-- 8. Rank employees within each organization by benefit rate.
SELECT
    organization_name,
    employee_name,
    role_name,
    benefit_rate,
    RANK() OVER (
        PARTITION BY organization_name
        ORDER BY benefit_rate DESC
    ) AS benefit_rank_in_organization
FROM employee_profile
ORDER BY organization_name, benefit_rank_in_organization, employee_name;

-- 9. Find roles that appear more than five times in the workforce.
SELECT
    role_name,
    COUNT(*) AS role_count
FROM employee_profile
GROUP BY role_name
HAVING COUNT(*) > 5
ORDER BY role_count DESC;

-- 10. Summary of employee status across the full organization.
SELECT
    employment_status,
    COUNT(*) AS total_employees
FROM employee
GROUP BY employment_status
ORDER BY total_employees DESC;

-- 11. Employees assigned to Banking and Financial Services organizations.
SELECT
    employee_id,
    employee_name,
    role_name,
    organization_name,
    business_domain
FROM employee_profile
WHERE business_domain = 'Banking and Financial Services'
ORDER BY organization_name, employee_name;

-- 12. Average age by employee type.
SELECT
    et.employee_type_name,
    COUNT(e.employee_id) AS total_employees,
    ROUND(AVG(p.age), 1) AS average_age
FROM employee AS e
JOIN employee_type AS et
    ON e.employee_type_id = et.employee_type_id
JOIN person AS p
    ON e.person_id = p.person_id
GROUP BY et.employee_type_name
ORDER BY total_employees DESC, et.employee_type_name;
