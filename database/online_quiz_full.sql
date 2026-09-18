--
-- PostgreSQL database dump
--

\restrict VYJnaSphPBy2thGFlsgRHSesvVgzhGESW7kRN1gyGqdmta1yXdoWUFpuOCDDtDo

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
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.admins (id, first_name, middle_name, last_name, username, email, password_hash, created_at, updated_at) FROM stdin;
1	System	\N	Administrator	admin	admin@udom.ac.tz	65536:YmU0SMtb5pwsfa5SJxEcPQ==:I7qOquXYpAalFJACyn63SBEhgOgpsB9Rgap+SsAWG2U=	2026-09-06 12:01:52.912687	2026-09-11 00:02:43.157617
\.


--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.answers (id, question_id, option_label, answer_text, is_correct) FROM stdin;
233	59	A	1	t
234	59	B	2	f
235	59	C	3	f
236	59	D	4	f
241	61	A	a	f
242	61	B	b	f
243	61	C	c	t
244	61	D	d	f
245	62	A	a	t
246	62	B	b	f
247	62	C	c	f
248	62	D	d	f
249	63	A	a	f
250	63	B	b	t
251	63	C	c	f
252	63	D	d	f
237	60	A	Y	f
238	60	B	N	f
239	60	C	Y&N	f
240	60	D	HAHA	t
\.


--
-- Data for Name: colleges; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.colleges (id, name, created_at) FROM stdin;
1	College of Informatics and Virtual Education (CIVE)	2026-09-08 00:48:32.498942
3	College of Education (CoED)	2026-09-15 22:21:59.98936
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.courses (id, programme_id, course_code, course_name, year_of_study, created_at) FROM stdin;
1	1	CS 111	Introduction to Computer Programming	1	2026-09-08 00:50:01.848523
2	1	SE 112	Mathematics for Engineers I	1	2026-09-08 00:50:01.848523
3	1	CN 121	Computer Networks I	1	2026-09-08 00:50:01.848523
4	1	NW 122	Fundamentals of Cyber Security	1	2026-09-08 00:50:01.848523
5	1	DS 101	Development Studies	1	2026-09-08 00:50:01.848523
6	1	CL 111	Communication Skills	1	2026-09-08 00:50:01.848523
7	1	CP 226	Operating Systems	2	2026-09-08 00:50:09.542691
8	1	NW 211	Network Routing and Switching	2	2026-09-08 00:50:09.542691
9	1	NW 221	Cryptography and Network Security	2	2026-09-08 00:50:09.542691
10	1	CS 222	Database Management Systems	2	2026-09-08 00:50:09.542691
11	1	SE 212	Object-Oriented Programming	2	2026-09-08 00:50:09.542691
12	1	CS 212	Systems Analysis and Design	2	2026-09-08 00:50:09.542691
13	1	DF 311	Digital Forensics and Investigations	3	2026-09-08 00:50:16.223689
14	1	NW 321	Ethical Hacking and Penetration Testing	3	2026-09-08 00:50:16.223689
15	1	NW 322	Information Security Risk Management	3	2026-09-08 00:50:16.223689
16	1	CP 322	Data Warehousing and Data Mining	3	2026-09-08 00:50:16.223689
17	1	CS 312	Web Technologies and Security	3	2026-09-08 00:50:16.223689
18	1	SE 322	Secure Software Engineering	3	2026-09-08 00:50:16.223689
19	1	DF 411	Advanced Digital Forensics	4	2026-09-08 00:50:23.110342
20	1	NW 412	Cyber Law, Ethics, and Compliance	4	2026-09-08 00:50:23.110342
21	1	NW 421	Wireless and Mobile Security	4	2026-09-08 00:50:23.110342
22	1	CP 423	Systems Administration and Management	4	2026-09-08 00:50:23.110342
23	1	DF 499	Final Year Engineering Project	4	2026-09-08 00:50:23.110342
24	2	CS 111	Introduction to Computer Programming	1	2026-09-08 00:50:32.143856
25	2	SE 111	Essential Mathematics for Software Engineers	1	2026-09-08 00:50:32.143856
26	2	SE 112	Software Engineering Fundamentals	1	2026-09-08 00:50:32.143856
27	2	CN 121	Computer Networks I	1	2026-09-08 00:50:32.143856
28	2	DS 101	Development Studies	1	2026-09-08 00:50:32.143856
29	2	CL 111	Communication Skills	1	2026-09-08 00:50:32.143856
30	2	SE 211	Object-Oriented Programming	2	2026-09-08 00:50:38.253545
31	2	CS 212	Systems Analysis and Design	2	2026-09-08 00:50:38.253545
32	2	SE 213	Data Structures and Algorithms	2	2026-09-08 00:50:38.253545
33	2	CS 222	Database Management Systems	2	2026-09-08 00:50:38.253545
34	2	CP 226	Operating Systems	2	2026-09-08 00:50:38.253545
35	2	SE 224	Software Requirements Engineering	2	2026-09-08 00:50:38.253545
36	2	SE 311	Software Architecture and Design	3	2026-09-08 00:50:44.80977
37	2	SE 312	Software Testing and Quality Assurance	3	2026-09-08 00:50:44.80977
38	2	CS 312	Web Technologies and Applications	3	2026-09-08 00:50:44.80977
39	2	SE 321	Software Project Management	3	2026-09-08 00:50:44.80977
40	2	CP 322	Data Warehousing and Data Mining	3	2026-09-08 00:50:44.80977
41	2	SE 399	Research Methodology and Pre-Project	3	2026-09-08 00:50:44.80977
42	2	SE 411	Advanced Software Engineering	4	2026-09-08 00:50:51.678805
43	2	SE 412	Enterprise Application Development	4	2026-09-08 00:50:51.678805
44	2	SE 421	Cloud Computing and Distributed Systems	4	2026-09-08 00:50:51.678805
45	2	NW 412	Cyber Law, Ethics, and Professional Practice	4	2026-09-08 00:50:51.678805
46	2	SE 499	Final Year Project	4	2026-09-08 00:50:51.678805
47	3	CS 111	Introduction to Computer Programming	1	2026-09-11 09:56:17.844998
48	3	SE 112	Mathematics for Engineers I	1	2026-09-11 09:59:10.659448
49	3	CN 121	Computer Networks I	1	2026-09-11 10:01:06.500418
50	3	IS 113	Introduction to Information Systems	1	2026-09-11 10:01:51.961684
51	3	DS 101	Development Studies	1	2026-09-11 10:05:07.969491
52	3	CL 111	Communication Skills	1	2026-09-11 10:07:31.491443
53	3	CP 226	Operating Systems	2	2026-09-11 10:10:19.974793
54	3	NW 211	Network Routing and Switching	2	2026-09-11 10:11:52.541516
55	3	NW 221	Cryptography and Network Security	2	2026-09-11 10:13:39.824898
56	3	CS 222	Database Management Systems	2	2026-09-11 10:14:57.107389
57	3	SE 212	Object-Oriented Programming	2	2026-09-11 10:15:58.012944
58	3	CS 212	Systems Analysis and Design	2	2026-09-11 10:17:56.037956
59	3	NW 311	Advanced Network Routing and Switching	3	2026-09-11 10:19:07.445344
60	3	NW 321	Ethical Hacking and Penetration Testing	3	2026-09-11 10:20:50.079376
61	3	NW 322	Information Security Risk Management	3	2026-09-11 10:21:55.873851
62	3	CN 323	Network Design and Management	3	2026-09-11 10:22:54.890852
63	3	CS 312	Web Technologies and Security	3	2026-09-11 10:23:54.418786
64	3	NW 399	Research Methodology and Pre-Project	3	2026-09-11 10:25:03.110473
65	3	NW 411	Network Security Architecture	4	2026-09-11 10:30:11.689806
66	3	NW 412	Cyber Law, Ethics, and Compliance	4	2026-09-11 10:31:29.894241
67	3	NW 421	Wireless and Mobile Security	4	2026-09-11 10:32:45.704866
68	3	CP 423	Systems Administration and Management	4	2026-09-11 10:33:58.267464
69	3	NW 499	Final Year Engineering Project	4	2026-09-11 10:34:45.114346
70	4	FE 111	Principles of Education	1	2026-09-15 22:23:57.349594
71	4	EP 101	Introduction to Educational Psychology	1	2026-09-15 22:24:48.084736
72	4	SN 111	Introduction to Special Needs Education	1	2026-09-15 22:25:24.197376
73	4	SN 123	Introduction to Sign Language	1	2026-09-15 22:26:04.029191
74	4	SN 122	Introduction to Visual Impairment	1	2026-09-15 22:26:31.134624
\.


--
-- Data for Name: programmes; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.programmes (id, college_id, name, created_at) FROM stdin;
1	1	Bachelor of Science in Cyber Security and Digital Forensics Engineering (BSc. CSDFE)	2026-09-08 00:48:57.147942
2	1	Bachelor of Science in Software Engineering (BSc. SE)	2026-09-08 00:49:07.271567
3	1	Bachelor of Science in Computer Networks and Information Security Engineering (BSc. CNISE)	2026-09-11 09:55:11.875341
4	3	Bachelor of Education in Science	2026-09-15 22:22:58.729544
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.questions (id, quiz_id, question_text, question_number) FROM stdin;
59	20	1.TEST	1
61	21	1	1
62	22	1	1
63	22	2	2
60	20	TEST 2	2
\.


--
-- Data for Name: quiz_attempt_answers; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.quiz_attempt_answers (id, attempt_id, question_id, selected_option, is_correct) FROM stdin;
1	1	59	B	f
2	1	60	C	f
3	2	62	D	f
4	2	63	B	t
33	6	59	A	t
34	6	60	D	t
\.


--
-- Data for Name: quiz_attempts; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.quiz_attempts (id, quiz_id, student_id, score, total_questions, percentage, result_status, started_at, submitted_at) FROM stdin;
1	20	12	0	2	0.00	FAIL	2026-09-09 23:17:18.932713	2026-09-09 23:17:18.932713
2	22	12	1	2	50.00	PASS	2026-09-09 23:17:37.709799	2026-09-09 23:17:37.709799
6	20	14	2	2	100.00	PASS	2026-09-16 11:23:07.777327	2026-09-16 11:23:07.777327
\.


--
-- Data for Name: quizzes; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.quizzes (id, title, course, description, duration_minutes, question_count, pass_mark, status, created_at, updated_at, teacher_id, course_id) FROM stdin;
20	CL 111 FIRST QUIZ	Computer Security	CCWCWCC	2	2	50	PUBLISHED	2026-09-08 08:15:49.650982	2026-09-08 08:17:09.19717	6	\N
22	test2	CN 121 - Computer Networks I	bhjbjn	2	2	50	PUBLISHED	2026-09-08 08:41:29.780966	2026-09-08 08:42:30.779865	6	27
21	test1	CN 121 - Computer Networks I	w	1	2	100	DRAFT	2026-09-08 08:40:08.126667	2026-09-09 11:14:21.645822	6	27
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.students (id, first_name, middle_name, last_name, gender, date_of_birth, registration_number, college, programme, year_of_study, email, phone, password_hash, created_at, updated_at) FROM stdin;
3	test3	yes	test3	MALE	2000-07-23	T25-03-111122	College of Earth Sciences	BSc.CSDFE	1	test3@gmail.com	0876543221	65536:omcneR+NTSKus5HjO3tzfQ==:8UwGa+UVtU8ixNEBvaLQtv9sRT6JQwSvoUj31cYt16k=	2026-09-06 09:04:53.293263	2026-09-06 09:04:53.293263
4	faith	geofrey	ibobo	FEMALE	2007-06-08	T25-03-11411	College of Informatics and Virtual Education	Bsc.CSDFE	1	faithibobo@gmail.com	0623841489	65536:WYr/GdnLhJXLW/UKtTX4DQ==:T7VmkhuUYp3IPjE7J5VF6tx/2cA59/gSuG71K+Lyb8M=	2026-09-07 09:19:40.116853	2026-09-07 09:19:40.116853
6	jaliwa	mlukozi	ng'hodya	MALE	2025-03-09	T25-03-12301	College of Informatics and Virtual Education	BSC.TE	1	jaliwasamwel14@gmail.com	+255 683315082	65536:DlMkzogUb72GcIUTeB+uXw==:ullJC2sRt0+/cclqKFuzd6dcwcZjthxMmmP9ZDtfEzI=	2026-09-09 10:35:33.355315	2026-09-09 10:35:33.355315
7	mwiteki	marato	chacha	MALE	2004-09-13	T25-03-18802	College of Informatics and Virtual Education	BSC SE	1	richardkenny252@gmail.com	0741997096	65536:9u3KFNykepwWgkm+onzp/w==:KeOp/03I439YSaWABqUDXBndki5CiDQP7qRtbItXYiY=	2026-09-09 10:47:13.588685	2026-09-09 10:47:13.588685
8	Nunu	Apianus	Ndabilinde	FEMALE	2005-05-09	T25-03-19999	College of Informatics and Virtual Education	BSc.SE	4	nuapianus@gmail.com	0700 121 121	65536:k8FiLuvmSAQlg3M3Rq2/xQ==:rjImNR8ejgXw2eBsfb4+I4DM8KbkTorEzpvGdHIgH9A=	2026-09-09 10:48:57.962118	2026-09-09 10:48:57.962118
10	nunu	Apianus	Ndabilinde	FEMALE	2005-05-09	T25-03-19998	College of Informatics and Virtual Education	BSc.SE	4	nunuapianus@gmail.com	0700 121 121	65536:0OXe1H+m5XBGszj83WQbrg==:54VclVC+dXMidGGiAZ3V1f2hqfZP+Nufm/sy2SHGvfQ=	2026-09-09 11:10:35.701983	2026-09-09 11:10:35.701983
5	student	\N	student	MALE	2026-09-07	T25-03-114114	College of Informatics and Virtual Education	Bsc.CSDFE	1	student@gmail.com	0717171717	65536:YR4SKAM9O2pI3sytezLW3w==:QQ/3Ju5PdLzmmN8shufLS4iJHED9dDgD7MHlzFh73Z0=	2026-09-07 23:54:02.478682	2026-09-10 01:23:09.096982
12	student	test	student	FEMALE	2026-09-09	T25-03-10000	College of Informatics and Virtual Education	Bsc.CSDFE	1	student1@gmail.com	0788221133	65536:C1DDrLhI6nOCLpD3fhKmHA==:oEwY54ow5CC9L59w9abWpeRYdCsdB3utWE396JKmB1E=	2026-09-09 23:15:45.906599	2026-09-10 23:34:11.92933
13	Rasuli	mohamed	Omari	MALE	2023-03-02	T25-03-10011	College of Informatics and Virtual Education	BSc.SE	1	mdudu@udom.ac.tz	0717171717	65536:gw28CBmJ151yqAXE6ouorA==:HxQUUCR1k4xrL3pupHebalKpTDaGB7s1FyCOD7ekvFk=	2026-09-16 10:45:57.334661	2026-09-16 10:45:57.334661
14	maggie	jackson	matonya	FEMALE	2026-09-16	T25-03-111145	College of Informatics and Virtual Education	BSc.SE	2	maggie13@gmail.com	+255784565645	65536:AohpE6Y67aYj9VHNGwLIug==:eDrlzx7I8pRoSCwpJBaYBT9Sz8HVPNHBP31Oui4Yazw=	2026-09-16 11:20:56.440492	2026-09-16 11:20:56.440492
\.


--
-- Data for Name: teacher_courses; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.teacher_courses (id, teacher_id, course_id, assigned_at) FROM stdin;
2	6	6	2026-09-08 02:22:33.589514
3	6	27	2026-09-08 02:22:45.809684
4	6	43	2026-09-08 10:42:30.391938
5	5	14	2026-09-09 10:57:24.325474
6	5	18	2026-09-09 10:57:24.325474
\.


--
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.teachers (id, first_name, middle_name, last_name, staff_number, college, department, email, phone, password_hash, created_at, updated_at) FROM stdin;
5	Nunu	Mohamed	Kinunga	UDOM/STAFF/006	College of Informatics and Virtual Education	CS	kinunganuru@gmail.com	0752 811 556	65536:fLCM9oROyk0FCzMEUoLb4g==:7cT4g1YWtpIWr3SYAdXWayaLLekqZ/u5CDZDqzws0Ko=	2026-09-07 09:37:36.374615	2026-09-07 09:37:36.374615
6	teacher	\N	teacher	UDOM/STAFF/005	College of Informatics and Virtual Education	CS	teacher@udom.ac.tz	0666000000	65536:CT1L7eTldcpcOnfAp+eo3w==:6b9sGvh1BSIXg7vx7fLAiXMzZ29PsMdM4y42UsyGBd4=	2026-09-07 23:09:59.064915	2026-09-07 23:09:59.064915
1	MKONGWE	\N	PAMA	UDOM/STAFF/001	College of Informatics and Virtual Education	CS	mkongwe@udom.ac.tz	0717171718	65536:qG5c4Xjjb5Qmg7bD1vgPVg==:JL/hn4TkVpmtLWHUAn+Ebu5TVFcyLX84t9O93l+YKug=	2026-09-06 14:44:13.948406	2026-09-10 10:58:19.031703
\.


--
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.admins_id_seq', 1, true);


--
-- Name: answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.answers_id_seq', 252, true);


--
-- Name: colleges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.colleges_id_seq', 3, true);


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.courses_id_seq', 74, true);


--
-- Name: programmes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.programmes_id_seq', 4, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.questions_id_seq', 63, true);


--
-- Name: quiz_attempt_answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.quiz_attempt_answers_id_seq', 34, true);


--
-- Name: quiz_attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.quiz_attempts_id_seq', 6, true);


--
-- Name: quizzes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.quizzes_id_seq', 22, true);


--
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.students_id_seq', 14, true);


--
-- Name: teacher_courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.teacher_courses_id_seq', 6, true);


--
-- Name: teachers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.teachers_id_seq', 6, true);


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

\unrestrict VYJnaSphPBy2thGFlsgRHSesvVgzhGESW7kRN1gyGqdmta1yXdoWUFpuOCDDtDo

