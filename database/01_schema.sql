--
-- PostgreSQL database dump
--

\restrict YCZttjuFxvfuOqV4x20DnQwTVpusRYDQwvqnewA1swOPfg5eh75yf2V5KmTQh9X

-- Dumped from database version 18.4 (Debian 18.4-1)
-- Dumped by pg_dump version 18.4 (Debian 18.4-1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: admin
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    middle_name character varying(100),
    last_name character varying(100) NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.admins OWNER TO admin;

--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admins_id_seq OWNER TO admin;

--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.answers (
    id integer NOT NULL,
    question_id integer NOT NULL,
    option_label character(1) NOT NULL,
    answer_text text NOT NULL,
    is_correct boolean DEFAULT false NOT NULL,
    CONSTRAINT valid_option_label CHECK ((option_label = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar, 'D'::bpchar])))
);


ALTER TABLE public.answers OWNER TO admin;

--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.answers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.answers_id_seq OWNER TO admin;

--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.answers_id_seq OWNED BY public.answers.id;


--
-- Name: colleges; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.colleges (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.colleges OWNER TO admin;

--
-- Name: colleges_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.colleges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.colleges_id_seq OWNER TO admin;

--
-- Name: colleges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.colleges_id_seq OWNED BY public.colleges.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.courses (
    id integer NOT NULL,
    programme_id integer NOT NULL,
    course_code character varying(50) NOT NULL,
    course_name character varying(200) NOT NULL,
    year_of_study integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_course_year CHECK (((year_of_study >= 1) AND (year_of_study <= 4)))
);


ALTER TABLE public.courses OWNER TO admin;

--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.courses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.courses_id_seq OWNER TO admin;

--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;


--
-- Name: programmes; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.programmes (
    id integer NOT NULL,
    college_id integer NOT NULL,
    name character varying(200) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.programmes OWNER TO admin;

--
-- Name: programmes_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.programmes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.programmes_id_seq OWNER TO admin;

--
-- Name: programmes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.programmes_id_seq OWNED BY public.programmes.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    quiz_id integer NOT NULL,
    question_text text NOT NULL,
    question_number integer NOT NULL
);


ALTER TABLE public.questions OWNER TO admin;

--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.questions_id_seq OWNER TO admin;

--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: quiz_attempt_answers; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.quiz_attempt_answers (
    id integer NOT NULL,
    attempt_id integer NOT NULL,
    question_id integer NOT NULL,
    selected_option character(1),
    is_correct boolean DEFAULT false NOT NULL,
    CONSTRAINT valid_selected_option CHECK (((selected_option IS NULL) OR (selected_option = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar, 'D'::bpchar]))))
);


ALTER TABLE public.quiz_attempt_answers OWNER TO admin;

--
-- Name: quiz_attempt_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.quiz_attempt_answers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quiz_attempt_answers_id_seq OWNER TO admin;

--
-- Name: quiz_attempt_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.quiz_attempt_answers_id_seq OWNED BY public.quiz_attempt_answers.id;


--
-- Name: quiz_attempts; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.quiz_attempts (
    id integer NOT NULL,
    quiz_id integer NOT NULL,
    student_id integer NOT NULL,
    score integer DEFAULT 0 NOT NULL,
    total_questions integer NOT NULL,
    percentage numeric(5,2) NOT NULL,
    result_status character varying(10) NOT NULL,
    started_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_result_status CHECK (((result_status)::text = ANY ((ARRAY['PASS'::character varying, 'FAIL'::character varying])::text[])))
);


ALTER TABLE public.quiz_attempts OWNER TO admin;

--
-- Name: quiz_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.quiz_attempts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quiz_attempts_id_seq OWNER TO admin;

--
-- Name: quiz_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.quiz_attempts_id_seq OWNED BY public.quiz_attempts.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.quizzes (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    course character varying(150) NOT NULL,
    description text,
    duration_minutes integer NOT NULL,
    question_count integer NOT NULL,
    pass_mark integer NOT NULL,
    status character varying(20) DEFAULT 'DRAFT'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    teacher_id integer,
    course_id integer
);


ALTER TABLE public.quizzes OWNER TO admin;

--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.quizzes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quizzes_id_seq OWNER TO admin;

--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.quizzes_id_seq OWNED BY public.quizzes.id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.students (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    middle_name character varying(100),
    last_name character varying(100) NOT NULL,
    gender character varying(10) NOT NULL,
    date_of_birth date NOT NULL,
    registration_number character varying(50) NOT NULL,
    college character varying(200) NOT NULL,
    programme character varying(200) NOT NULL,
    year_of_study integer NOT NULL,
    email character varying(150) NOT NULL,
    phone character varying(30) NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_gender CHECK (((gender)::text = ANY ((ARRAY['MALE'::character varying, 'FEMALE'::character varying])::text[]))),
    CONSTRAINT valid_year_of_study CHECK (((year_of_study >= 1) AND (year_of_study <= 4)))
);


ALTER TABLE public.students OWNER TO admin;

--
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.students_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_id_seq OWNER TO admin;

--
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.students_id_seq OWNED BY public.students.id;


--
-- Name: teacher_courses; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.teacher_courses (
    id integer NOT NULL,
    teacher_id integer NOT NULL,
    course_id integer NOT NULL,
    assigned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.teacher_courses OWNER TO admin;

--
-- Name: teacher_courses_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.teacher_courses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teacher_courses_id_seq OWNER TO admin;

--
-- Name: teacher_courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.teacher_courses_id_seq OWNED BY public.teacher_courses.id;


--
-- Name: teachers; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.teachers (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    middle_name character varying(100),
    last_name character varying(100) NOT NULL,
    staff_number character varying(50) NOT NULL,
    college character varying(200) NOT NULL,
    department character varying(200) NOT NULL,
    email character varying(150) NOT NULL,
    phone character varying(30) NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.teachers OWNER TO admin;

--
-- Name: teachers_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.teachers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teachers_id_seq OWNER TO admin;

--
-- Name: teachers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.teachers_id_seq OWNED BY public.teachers.id;


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: answers id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.answers ALTER COLUMN id SET DEFAULT nextval('public.answers_id_seq'::regclass);


--
-- Name: colleges id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.colleges ALTER COLUMN id SET DEFAULT nextval('public.colleges_id_seq'::regclass);


--
-- Name: courses id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);


--
-- Name: programmes id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.programmes ALTER COLUMN id SET DEFAULT nextval('public.programmes_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: quiz_attempt_answers id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quiz_attempt_answers ALTER COLUMN id SET DEFAULT nextval('public.quiz_attempt_answers_id_seq'::regclass);


--
-- Name: quiz_attempts id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quiz_attempts ALTER COLUMN id SET DEFAULT nextval('public.quiz_attempts_id_seq'::regclass);


--
-- Name: quizzes id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quizzes ALTER COLUMN id SET DEFAULT nextval('public.quizzes_id_seq'::regclass);


--
-- Name: students id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_id_seq'::regclass);


--
-- Name: teacher_courses id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.teacher_courses ALTER COLUMN id SET DEFAULT nextval('public.teacher_courses_id_seq'::regclass);


--
-- Name: teachers id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.teachers ALTER COLUMN id SET DEFAULT nextval('public.teachers_id_seq'::regclass);


--
-- Name: admins admins_email_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_email_key UNIQUE (email);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: admins admins_username_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_username_key UNIQUE (username);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: colleges colleges_name_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.colleges
    ADD CONSTRAINT colleges_name_key UNIQUE (name);


--
-- Name: colleges colleges_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.colleges
    ADD CONSTRAINT colleges_pkey PRIMARY KEY (id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: programmes programmes_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.programmes
    ADD CONSTRAINT programmes_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: quiz_attempt_answers quiz_attempt_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quiz_attempt_answers
    ADD CONSTRAINT quiz_attempt_answers_pkey PRIMARY KEY (id);


--
-- Name: quiz_attempts quiz_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quiz_attempts
    ADD CONSTRAINT quiz_attempts_pkey PRIMARY KEY (id);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: students students_email_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_email_key UNIQUE (email);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: students students_registration_number_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_registration_number_key UNIQUE (registration_number);


--
-- Name: teacher_courses teacher_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.teacher_courses
    ADD CONSTRAINT teacher_courses_pkey PRIMARY KEY (id);


--
-- Name: teachers teachers_email_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_email_key UNIQUE (email);


--
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id);


--
-- Name: teachers teachers_staff_number_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_staff_number_key UNIQUE (staff_number);


--
-- Name: quiz_attempt_answers unique_attempt_question; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quiz_attempt_answers
    ADD CONSTRAINT unique_attempt_question UNIQUE (attempt_id, question_id);


--
-- Name: courses unique_course_per_programme; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT unique_course_per_programme UNIQUE (programme_id, course_code);


--
-- Name: programmes unique_programme_per_college; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.programmes
    ADD CONSTRAINT unique_programme_per_college UNIQUE (college_id, name);


--
-- Name: quiz_attempts unique_student_quiz_attempt; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quiz_attempts
    ADD CONSTRAINT unique_student_quiz_attempt UNIQUE (quiz_id, student_id);


--
-- Name: teacher_courses unique_teacher_course; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.teacher_courses
    ADD CONSTRAINT unique_teacher_course UNIQUE (teacher_id, course_id);


--
-- Name: answers fk_answers_question; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT fk_answers_question FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: quiz_attempt_answers fk_attempt_answers_attempt; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quiz_attempt_answers
    ADD CONSTRAINT fk_attempt_answers_attempt FOREIGN KEY (attempt_id) REFERENCES public.quiz_attempts(id) ON DELETE CASCADE;


--
-- Name: quiz_attempt_answers fk_attempt_answers_question; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quiz_attempt_answers
    ADD CONSTRAINT fk_attempt_answers_question FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: quiz_attempts fk_attempts_quiz; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quiz_attempts
    ADD CONSTRAINT fk_attempts_quiz FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: quiz_attempts fk_attempts_student; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quiz_attempts
    ADD CONSTRAINT fk_attempts_student FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: courses fk_courses_programme; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT fk_courses_programme FOREIGN KEY (programme_id) REFERENCES public.programmes(id) ON DELETE CASCADE;


--
-- Name: programmes fk_programmes_college; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.programmes
    ADD CONSTRAINT fk_programmes_college FOREIGN KEY (college_id) REFERENCES public.colleges(id) ON DELETE CASCADE;


--
-- Name: questions fk_questions_quiz; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT fk_questions_quiz FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: quizzes fk_quizzes_course; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT fk_quizzes_course FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;


--
-- Name: quizzes fk_quizzes_teacher; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT fk_quizzes_teacher FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE CASCADE;


--
-- Name: teacher_courses fk_teacher_courses_course; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.teacher_courses
    ADD CONSTRAINT fk_teacher_courses_course FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;


--
-- Name: teacher_courses fk_teacher_courses_teacher; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.teacher_courses
    ADD CONSTRAINT fk_teacher_courses_teacher FOREIGN KEY (teacher_id) REFERENCES public.teachers(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict YCZttjuFxvfuOqV4x20DnQwTVpusRYDQwvqnewA1swOPfg5eh75yf2V5KmTQh9X

