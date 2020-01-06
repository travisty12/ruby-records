--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5
-- Dumped by pg_dump version 11.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: albums; Type: TABLE; Schema: public; Owner: travistoal
--

CREATE TABLE public.albums (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.albums OWNER TO travistoal;

--
-- Name: albums_artists; Type: TABLE; Schema: public; Owner: travistoal
--

CREATE TABLE public.albums_artists (
    id integer NOT NULL,
    artist_id integer,
    album_id integer
);


ALTER TABLE public.albums_artists OWNER TO travistoal;

--
-- Name: albums_artists_id_seq; Type: SEQUENCE; Schema: public; Owner: travistoal
--

CREATE SEQUENCE public.albums_artists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.albums_artists_id_seq OWNER TO travistoal;

--
-- Name: albums_artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: travistoal
--

ALTER SEQUENCE public.albums_artists_id_seq OWNED BY public.albums_artists.id;


--
-- Name: albums_id_seq; Type: SEQUENCE; Schema: public; Owner: travistoal
--

CREATE SEQUENCE public.albums_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.albums_id_seq OWNER TO travistoal;

--
-- Name: albums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: travistoal
--

ALTER SEQUENCE public.albums_id_seq OWNED BY public.albums.id;


--
-- Name: artists; Type: TABLE; Schema: public; Owner: travistoal
--

CREATE TABLE public.artists (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.artists OWNER TO travistoal;

--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: travistoal
--

CREATE SEQUENCE public.artists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.artists_id_seq OWNER TO travistoal;

--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: travistoal
--

ALTER SEQUENCE public.artists_id_seq OWNED BY public.artists.id;


--
-- Name: songs; Type: TABLE; Schema: public; Owner: travistoal
--

CREATE TABLE public.songs (
    id integer NOT NULL,
    name character varying,
    album_id integer
);


ALTER TABLE public.songs OWNER TO travistoal;

--
-- Name: songs_id_seq; Type: SEQUENCE; Schema: public; Owner: travistoal
--

CREATE SEQUENCE public.songs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.songs_id_seq OWNER TO travistoal;

--
-- Name: songs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: travistoal
--

ALTER SEQUENCE public.songs_id_seq OWNED BY public.songs.id;


--
-- Name: albums id; Type: DEFAULT; Schema: public; Owner: travistoal
--

ALTER TABLE ONLY public.albums ALTER COLUMN id SET DEFAULT nextval('public.albums_id_seq'::regclass);


--
-- Name: albums_artists id; Type: DEFAULT; Schema: public; Owner: travistoal
--

ALTER TABLE ONLY public.albums_artists ALTER COLUMN id SET DEFAULT nextval('public.albums_artists_id_seq'::regclass);


--
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: travistoal
--

ALTER TABLE ONLY public.artists ALTER COLUMN id SET DEFAULT nextval('public.artists_id_seq'::regclass);


--
-- Name: songs id; Type: DEFAULT; Schema: public; Owner: travistoal
--

ALTER TABLE ONLY public.songs ALTER COLUMN id SET DEFAULT nextval('public.songs_id_seq'::regclass);


--
-- Data for Name: albums; Type: TABLE DATA; Schema: public; Owner: travistoal
--

COPY public.albums (id, name) FROM stdin;
1	Kind of Blue
4	Bitches Brew
3	Nefertiti
2	Giant Steps
\.


--
-- Data for Name: albums_artists; Type: TABLE DATA; Schema: public; Owner: travistoal
--

COPY public.albums_artists (id, artist_id, album_id) FROM stdin;
4	2	3
7	2	4
11	2	1
18	3	2
\.


--
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: travistoal
--

COPY public.artists (id, name) FROM stdin;
2	Miles Davis
3	John Coltrane
\.


--
-- Data for Name: songs; Type: TABLE DATA; Schema: public; Owner: travistoal
--

COPY public.songs (id, name, album_id) FROM stdin;
5	So What	1
6	Cousin Mary	2
7	Spanish Key	4
8	Freddie Freeloader	1
9	Hand Jive	3
10	Sanctuary	4
11	Spiral	2
\.


--
-- Name: albums_artists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: travistoal
--

SELECT pg_catalog.setval('public.albums_artists_id_seq', 18, true);


--
-- Name: albums_id_seq; Type: SEQUENCE SET; Schema: public; Owner: travistoal
--

SELECT pg_catalog.setval('public.albums_id_seq', 4, true);


--
-- Name: artists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: travistoal
--

SELECT pg_catalog.setval('public.artists_id_seq', 3, true);


--
-- Name: songs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: travistoal
--

SELECT pg_catalog.setval('public.songs_id_seq', 11, true);


--
-- Name: albums_artists albums_artists_pkey; Type: CONSTRAINT; Schema: public; Owner: travistoal
--

ALTER TABLE ONLY public.albums_artists
    ADD CONSTRAINT albums_artists_pkey PRIMARY KEY (id);


--
-- Name: albums albums_pkey; Type: CONSTRAINT; Schema: public; Owner: travistoal
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (id);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: travistoal
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: public; Owner: travistoal
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

