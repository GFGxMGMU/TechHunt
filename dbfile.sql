--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

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

--
-- Name: generate_random_string(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_random_string(length integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    chars TEXT := 'abcdefghijklmnopqrstuvwxyz0123456789';
    result TEXT := '';
BEGIN
    FOR i IN 1..length LOOP
        result := result || substring(chars FROM floor(random() * length(chars) + 1)::int FOR 1);
    END LOOP;
    RETURN result;
END;
$$;


ALTER FUNCTION public.generate_random_string(length integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access_codes (
    code text NOT NULL,
    loc_id integer
);


ALTER TABLE public.access_codes OWNER TO postgres;

--
-- Name: hints; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hints (
    loc_id integer NOT NULL,
    hint text
);


ALTER TABLE public.hints OWNER TO postgres;

--
-- Name: location_count; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_count (
    loc_id integer NOT NULL,
    passed_count integer DEFAULT 0
);


ALTER TABLE public.location_count OWNER TO postgres;

--
-- Name: location_next; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_next (
    loc_now integer,
    loc_next integer
);


ALTER TABLE public.location_next OWNER TO postgres;

--
-- Name: location_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_users (
    user_id uuid,
    loc_id integer
);


ALTER TABLE public.location_users OWNER TO postgres;

--
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    loc_name text NOT NULL,
    round_num integer,
    loc_id integer NOT NULL
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    que_id uuid DEFAULT gen_random_uuid() NOT NULL,
    question text,
    option1 text,
    option2 text,
    option3 text,
    option4 text,
    correct integer,
    loc_id integer,
    CONSTRAINT questions_correct_check CHECK (((correct >= 1) AND (correct <= 4)))
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: rounds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rounds (
    round_num integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.rounds OWNER TO postgres;

--
-- Name: user_rounds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_rounds (
    user_id uuid NOT NULL,
    round_num integer NOT NULL,
    entered_at timestamp without time zone,
    submitted boolean DEFAULT false
);


ALTER TABLE public.user_rounds OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id uuid DEFAULT gen_random_uuid() NOT NULL,
    team_name character varying(250),
    key character varying(250) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: winner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.winner (
    user_id uuid
);


ALTER TABLE public.winner OWNER TO postgres;

--
-- Data for Name: access_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.access_codes (code, loc_id) FROM stdin;
alerg4fu8kb1fvfekh9c5cja	1
qqklomyq76y6w1ik55am1sb7	2
7prgfczgompb18a4loc7exro	3
hcqzpqq1dgms1o7mcfgk7sy6	4
3rs4gs7skdknaimw58gc0v2r	5
raft4r83gpepn21ct9yo1zpk	6
dxsvfa8sttpwmbf62mghdikj	7
0lpwbf71g9w4oolaslq0o2cs	8
8y7hqwzup7qz8zcfk6efwq68	9
24mqjj8jf7x0tn5oqivv6vlb	10
mgfumc4ts2hr1jo6xlo4jzbh	11
puxmkjq4ad8b4su9if6qbq5h	12
5u0zoy6nrvdwukg6bt3ezcc0	13
z9busnx0dna0nxn87ywe9u6k	14
5474tr37w7r283cx5oz4x5s1	15
\.


--
-- Data for Name: hints; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hints (loc_id, hint) FROM stdin;
1	Look near the old oak tree.
2	Check under the stone bench.
3	The key is hidden in the blue vase.
4	Search by the riverside.
5	The clue is in the red mailbox.
6	Look behind the waterfall.
7	Check the highest bookshelf.
8	The treasure is buried near the big rock.
9	Look under the third step.
10	The clue is hidden in the attic.
11	Check the hollow tree trunk.
12	Look near the fountain.
13	Search behind the old painting.
14	The key is under the floorboard.
15	Look near the broken statue.
\.


--
-- Data for Name: location_count; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_count (loc_id, passed_count) FROM stdin;
1	0
2	0
3	0
4	0
5	0
6	0
7	0
8	0
9	0
10	0
11	0
12	0
13	0
14	0
15	0
\.


--
-- Data for Name: location_next; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_next (loc_now, loc_next) FROM stdin;
1	9
2	9
3	10
4	10
5	11
6	11
7	12
8	12
9	13
10	13
11	14
12	14
13	15
14	15
\.


--
-- Data for Name: location_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_users (user_id, loc_id) FROM stdin;
3fcf0fa5-ea9c-4b9d-8d99-55175637b573	1
0c040bf3-613b-453e-8395-d4e22cd37dd0	1
9439b071-cd92-4a85-b492-a7eaad8d48cd	1
c8403bd6-ebbb-41f7-b232-1542fdc50bfd	1
132f91ff-e426-4ef8-a18a-a88fb2ed0472	2
b0fc951e-cecf-4f8b-a971-a3041560cc2c	2
43c2c4ba-38ef-4060-bde3-dfc8bed814d1	2
a76084e2-6c59-40bd-ac66-781740b11ee4	2
90e3c6f3-43bc-4464-9ef4-fe87257de68d	3
15c050ca-4244-4318-b262-989b9fd6c591	3
4635beff-63ef-4370-83d1-4cc98c43c58d	3
cbfdf7a9-a076-4f7d-a94a-8e2e5964e6d5	3
27979cb0-1b73-4e65-9523-231e38c185a0	4
8d732863-fc7a-43e9-8102-adb90c3e0800	4
eadf82d8-61d1-4767-890f-4e76b33ae342	4
b27eb79a-97c4-4103-a399-66d528e63e62	4
949a382f-0bac-4cf9-9a0f-aeb33ea37328	5
839b756c-143e-4c60-8232-794a6a8d57aa	5
c4f2365f-1323-4c2f-8b3b-840f1f07f1dd	5
5f1adcaf-9836-48e9-b003-54981b1112cc	5
7d000ba8-ce5d-4441-aadd-bbe99d94b7b9	6
50ddf17a-490e-425c-b406-99456392e9e1	6
87ff6a06-1d0b-4006-9c22-a5808014c7ac	6
616e0893-388c-473f-b5cc-df803242e6fb	6
7e01c64c-ddbf-4aa9-98fa-38223bc37ead	7
59c130d1-f386-463e-ae7f-4e36771d3b51	7
8348c298-0ea7-4a4a-8b43-aa3d7da3de2d	7
4fe16b5e-86ad-4e22-846b-c1217900e20a	7
08c64cf9-a684-42c4-9452-5d895e90957c	8
e4ebb98c-c0a1-4923-9ba2-f9aba4ca6b98	8
f7baaa5a-50c8-4b71-aacd-2259243470cb	8
f37b5add-b32b-4c0f-8311-2bfa58f744a3	8
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (loc_name, round_num, loc_id) FROM stdin;
location 1	1	1
location 2	1	2
location 3	1	3
location 4	1	4
location 5	1	5
location 6	1	6
location 7	1	7
location 8	1	8
location 9	2	9
location 10	2	10
location 11	2	11
location 12	2	12
location 13	3	13
location 14	3	14
location 15	4	15
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (que_id, question, option1, option2, option3, option4, correct, loc_id) FROM stdin;
06ebf8f4-818e-4b91-bc2f-5372a2b93bcc	What is the time complexity of binary search?	O(1)	O(log n)	O(n)	O(n log n)	2	1
aa21fe44-d0c3-45cb-a97c-bae6c4422411	What does CPU stand for?	Central Processing Unit	Computer Personal Unit	Central Programming Unit	Central Processing Unit	1	2
2a324515-f587-4321-a774-5df5599e10eb	Which data structure uses LIFO order?	Queue	Stack	Array	Linked List	2	3
e11b34c4-cffb-4361-af82-8d0201cc29f1	In which language is the Python interpreter written?	C	C++	Java	Python	1	4
bc70c5eb-82c5-4bee-8350-602fed40574c	What is the primary purpose of an operating system?	Manage hardware	Run applications	Provide security	All of the above	4	5
94e95106-d38c-40e9-8c66-9becbad17757	What does the acronym HTTP stand for?	HyperText Transfer Protocol	HyperText Transmission Protocol	HyperText Transport Protocol	HyperText Transfer Program	1	6
a3233b72-9646-4411-945c-5431397b01e0	Which algorithm is used for sorting?	Binary Search	Bubble Sort	Dijkstra's Algorithm	Kruskal's Algorithm	2	7
ee427194-d0d5-46e0-b50f-7bcc9bb90be9	What is the full form of RAM?	Read Access Memory	Random Access Memory	Read After Memory	Random Access Module	2	8
b73ab983-9509-498c-8bc9-3f8ea85fb5b0	Which of the following is a non-volatile memory?	RAM	Cache	Register	Flash Memory	4	9
87e026fe-89fd-4408-9ee5-3da9a47e28e6	In which layer of the OSI model does the IP protocol operate?	Application Layer	Transport Layer	Network Layer	Data Link Layer	3	10
6d48f9a2-84d2-4fdc-8af5-2201896e7e1d	What is the primary function of a compiler?	Execute code	Translate code	Debug code	Store code	2	11
d65e2a04-f403-4b81-8e4b-4ade81492d18	Which of these is an example of an operating system?	Python	Java	Windows	SQL	3	12
f323da77-b78d-4b3e-8a2a-14ac775b9125	What does SQL stand for?	Structured Query Language	Structured Question Language	Simple Query Language	Standard Query Language	1	13
c4f1d431-1a6a-442a-9e66-4936053a8b15	What is the use of a hash function?	Encrypt data	Generate unique keys	Sort data	Store data	2	14
42216940-4b67-411d-842c-5026a21a555d	Which type of database is MongoDB?	Relational Database	Document Database	Graph Database	Object Database	2	15
2ff19a08-f1b0-4d19-9c4f-be69be5e06d0	What does DNS stand for?	Domain Name System	Domain Name Service	Direct Name System	Dynamic Name Service	1	1
0ddb61fd-7be4-4950-ada1-6e709a0abd00	Which programming language is known for its use in web development?	C++	Python	JavaScript	Fortran	3	2
9f0112b6-a1a0-46d5-aa23-89475f170387	What does GUI stand for?	General User Interface	Graphical User Interface	Graph User Interface	General User Interaction	2	3
081dcf67-5234-446d-a7ae-140e86057aab	What is the purpose of an API?	Design web pages	Connect software components	Store data	Perform computations	2	4
a50cc978-250c-43ee-8055-b3c35f0274b6	Which of these is a dynamic programming technique?	Quick Sort	Knapsack Problem	Binary Search	Merge Sort	2	5
566f14ef-da8d-4472-8fac-7d3dc173d0fd	In which programming paradigm is Python primarily used?	Procedural	Functional	Object-Oriented	Logical	3	6
16150bff-1686-437f-9140-b1138831ee8e	What is an exception in programming?	An error message	A debugging tool	A runtime error	A code optimization	3	7
62e2d48c-b33d-4d29-8e72-f5a90d740293	Which of these is a high-level programming language?	Assembly	C	Java	Machine Language	3	8
8c43a879-c1a7-41a7-b2ab-791d4094cfb6	What does MVC stand for in software architecture?	Model-View-Controller	Module-View-Controller	Model-View-Configuration	Model-Variable-Controller	1	9
b023c9c1-3c1c-4aac-9b72-e0ff2a51c7b3	Which protocol is used for secure data transmission over the internet?	HTTP	FTP	HTTPS	SMTP	3	10
6a2730a3-c834-4124-a3f9-fa997a78d164	What is the purpose of a database index?	Speed up queries	Store data	Encrypt data	Backup data	1	11
27284f87-d52d-47a6-9021-4badbf00b3be	What is the main difference between TCP and UDP?	Reliability	Speed	Port Number	Encryption	1	12
c63053f2-1d13-416e-83f4-a66f414251c0	What does the acronym SQL stand for?	Structured Query Language	Structured Question Language	Simple Query Language	Standard Query Language	1	13
9f36a7bd-e362-4e16-95df-44a4be21c436	Which of these is a version control system?	Git	Docker	Kubernetes	Jenkins	1	14
7f28c2c1-72c7-46f9-beb5-d6382f1fedf8	What is the purpose of normalization in databases?	Reduce redundancy	Encrypt data	Backup data	Index data	1	15
5f90ddb0-e1aa-44ea-a34c-7e6a8ce5cc1d	What is a deadlock in database systems?	Data corruption	Process blocking	Memory leak	Network failure	2	1
9075324b-d921-427c-a183-03b09e0782e6	What does the acronym REST stand for?	Representational State Transfer	Resource State Transfer	Remote State Transfer	Read-Write State Transfer	1	2
cbc71765-a22d-4a45-adca-b29d523b4e9d	Which of the following is an example of a NoSQL database?	MySQL	PostgreSQL	Oracle	Cassandra	4	3
f779bea4-3fa3-44bb-a193-ed78eb604eb9	In computing, what does RAID stand for?	Redundant Array of Independent Disks	Rapid Array of Independent Disks	Redundant Array of Internet Disks	Rapid Array of Internet Disks	1	4
56ebb581-11d6-4674-ab84-20c8c58922bd	Which data structure is used to implement a priority queue?	Stack	Queue	Heap	Array	3	5
37e8ca8f-c5fa-4cc3-9412-386dae97e85a	What is the primary use of a semaphore in operating systems?	Synchronize processes	Manage memory	Handle interrupts	Execute threads	1	6
c2ac710e-8005-48d7-9fa7-168f4c4fdae7	Which algorithm is used for finding the shortest path in a graph?	Dijkstra's Algorithm	Bubble Sort	Merge Sort	Quick Sort	1	7
4f2865e6-24c3-48fc-9324-0470832f7fbe	What does the term "polymorphism" refer to in object-oriented programming?	Multiple forms of a method	Multiple classes	Multiple inheritance	Multiple objects	1	8
99494676-0b9f-46df-86dd-0cc0b0a633ba	What is the purpose of a stack in programming?	Temporary storage	Persistent storage	Permanent storage	Cache	1	9
ba55d5fa-06a8-414a-910e-d1f3ec281263	What is the full form of FTP?	File Transfer Protocol	File Transmission Protocol	File Transport Protocol	Fast Transfer Protocol	1	10
a5b26d66-a33f-4d0d-8c3f-1365c42551d2	Which of the following is an example of an interpreted language?	C	C++	Java	Python	4	11
a764fe21-003f-4c6b-b57b-bc70bf90ae4d	What is the purpose of a constructor in object-oriented programming?	Initialize objects	Destroy objects	Copy objects	Test objects	1	12
3114c539-65b0-459b-866b-db0e1a9afb13	Which type of graph traversal uses a queue?	Depth-First Search	Breadth-First Search	Dijkstra's Algorithm	A* Search	2	13
55d2de61-fd52-488d-890c-286ec2c6d56c	What is the primary function of a router?	Connect networks	Store ata	Translate code	Execute programs	1	14
a599daa4-a1f7-4bbd-9dd4-5f5933f65876	Which data structure is used to implement a linked list?	Array	Stack	Queue	Nodes	4	15
731c9ad7-c783-463c-b69c-0a97c51f2009	What does the acronym XML stand for?	Extensible Markup Language	Extra Markup Language	Extended Markup Language	Executable Markup Language	1	1
516817b6-5306-4461-959a-8533b2f3c7a8	In programming, what is an iterator?	An object that performs operations	A method to iterate over collections	A data structure for storing elements	A function for sorting	2	2
048ec821-5641-48a6-80b0-e8c14715c1c7	Which of these is not a programming language?	HTML	Java	C#	Ruby	1	3
62b5b6fb-a290-42be-93ec-7f7ba9b7c27a	What is the primary purpose of encryption?	Secure data	Backup data	Store data	Process data	1	4
cd846c1e-086d-42cc-b7c6-2d85ad149d4e	Which algorithm is used to find the minimum spanning tree of a graph?	Kruskal's Algorithm	Dijkstra's Algorithm	Bellman-Ford Algorithm	Floyd-Warshall Algorithm	1	5
0e9b53aa-8e2b-4aa9-8157-89c4ce3cea82	What does the acronym API stand for?	Application Programming Interface	Application Program Interface	Advanced Programming Interface	Automated Program Interface	1	6
5448f701-2074-4ad7-a624-74e0ee126acf	Which of these is an example of a stack operation?	Dequeue	Push	Pop	Enqueue	3	7
682c8ce1-bc01-4ed5-951b-0ec3af0f878b	In which type of database is data stored in tables?	Document Database	Relational Database	Graph Database	Key-Value Database	2	8
6ac377d6-97c8-4cdf-8a03-676798166853	What is the primary advantage of using virtual memory?	Increase speed	Increase storage capacity	Increase data security	Increase reliability	2	9
e75eea79-65a9-4be3-ab1e-1be769630423	Which of these is a commonly used version control system?	Jenkins	Git	Docker	Kubernetes	2	10
f51ef45b-20c9-4f96-ae4e-e81036e30dfb	What is the purpose of a linker in programming?	Combine object files	Compile source code	Debug code	Execute code	1	11
d4415ca3-40b7-4e73-8998-37e6c10d75a1	Which programming paradigm uses functions as first-class citizens?	Object-Oriented	Functional	Procedural	Logical	2	12
706e9600-7d21-4593-afe9-58d9818eecc4	What is the time complexity of a bubble sort?	O(n)	O(n log n)	O(n^2)	O(log n)	3	1
8a54f8bd-fd9f-4322-8d3c-c137515e36ff	Which of these is not a valid C++ access specifier?	public	protected	private	restricted	4	2
6ebeb851-60a3-4b5f-8ace-37bebba67c34	In which data structure are elements added or removed from one end only?	Queue	Stack	Array	Linked List	2	3
716d3577-70e1-4cba-a34b-a90bb0fe8e5d	Which sorting algorithm is based on the divide and conquer technique?	Quick Sort	Merge Sort	Bubble Sort	Insertion Sort	1	4
80d9ea86-7093-4f94-9eab-0e2405f59df8	What is the purpose of the 'void' keyword in Java?	Specify no return value	Define a class	Create a method	Declare a variable	1	5
0598e430-2214-4899-adea-6a8366dad842	Which of these is not a feature of object-oriented programming?	Inheritance	Encapsulation	Polymorphism	Iteration	4	6
5f9fe215-d133-4d93-b173-caf53061c059	What is the purpose of a database index?	Speed up query processing	Ensure data integrity	Store data securely	Back up data	1	7
7a004893-a174-4052-b71c-5e663f492795	Which language is known for its use in data science and machine learning?	Ruby	Java	Python	PHP	3	8
3b5543f4-4c7a-4bae-a1a1-557229600929	What is the purpose of the 'final' keyword in Java?	Prevent method overriding	Declare variables	Define constants	Control flow	1	9
ebfcc3f3-0145-4384-8212-1a53471e9ddc	Which data structure uses a "first-in, first-out" approach?	Stack	Queue	Array	Tree	2	10
cf4710cd-8942-40c0-ac32-4972faf8f0d0	What does API stand for in web development?	Application Programming Interface	Application Programming Internet	Advanced Programming Interface	Automated Programming Interface	1	11
851afbfa-38e6-4042-85a1-d63d36e96735	Which algorithm is used for encrypting data?	RSA	Bubble Sort	Dijkstra's Algorithm	Quick Sort	1	12
dc6c5d57-b0e4-4f32-a860-3cc2ff48d812	What is a primary key in a database?	A unique identifier for each record	A field that can be null	A data type for strings	A way to index data	1	13
a7e5cfbe-f81f-44c0-9071-fcb9e618b3f4	Which programming language is known for its use in system programming?	Python	C	Java	JavaScript	2	14
0ae7b549-b9dc-4c06-8058-e55982e05f51	What does the 'static' keyword indicate in C++?	A method or variable with class scope	A method or variable with instance scope	A class that cannot be instantiated	A constant value	1	15
147b3b4f-4c9f-4ed1-ac10-9e549549d21a	Which of these is a method for optimizing database performance?	Normalization	Denormalization	Indexing	All of the above	4	1
7696aa59-747d-4c3a-94fb-c61dc937958d	What is the purpose of the 'abstract' keyword in Java?	Define a class that cannot be instantiated	Create a constant variable	Initialize a variable	Handle exceptions	1	2
25f470c1-a35e-4119-8231-16266f32ab8a	Which data structure is used to implement recursion?	Queue	Stack	Array	Linked List	2	3
5bd5a676-a871-406e-bf41-ef9f1ebdfdd9	What is a class in object-oriented programming?	A blueprint for creating objects	A data structure for storing values	A method for handling exceptions	A function for processing data	1	4
957a95a6-19e5-4f8a-a837-36eee96b528d	What does the acronym URL stand for?	Uniform Resource Locator	Universal Resource Locator	Uniform Resource Link	Universal Resource Link	1	5
3274fad2-0a1b-4746-8a04-78c7470fa542	Which of these is not a feature of SQL?	Querying	Data Manipulation	Data Definition	Data Encryption	4	6
55a403db-8d62-4e3e-a7fd-56a5b846b43d	What is a join operation in SQL?	Combining rows from two or more tables	Creating indexes	Encrypting data	Deleting records	1	7
dc2dc1da-a9a7-4614-8992-757580344956	Which algorithm is commonly used for searching in a sorted array?	Binary Search	Linear Search	Hashing	Bubble Sort	1	8
27279273-a34d-48b0-becb-20020cf56ed1	What does the acronym DNS stand for in networking?	Domain Name System	Dynamic Name Service	Data Network Service	Domain Network Service	1	9
22e8a901-3a5d-48c6-b1a8-3c43517ff3e5	Which of these is a feature of functional programming?	Immutable data	Object-oriented design	Procedural steps	Event-driven design	1	10
287d7c7b-2f97-4ec7-b349-6afa03e32089	What is a semaphore in operating systems?	A signaling mechanism for process synchronization	A type of network protocol	A data storage method	An encryption algorithm	1	11
daba16f2-81d7-41d7-ab84-9d09a7deeec8	Which type of memory is volatile?	RAM	ROM	Flash Memory	Hard Disk	1	12
dda85c76-6bbe-4161-9eeb-7a3855c45a2e	What does the acronym JVM stand for?	Java Virtual Machine	Java Version Machine	Java Verified Machine	Java Variable Machine	1	13
7151b013-123a-460b-bb78-0018cdfcdb9e	What is a deadlock in computing?	A situation where two or more processes are unable to proceed	An error in network communication	A method of data encryption	A type of software bug	1	14
71c7e8fd-b19c-48aa-9613-c7a9269fd4c7	Which protocol is used to send emails?	SMTP	HTTP	FTP	DNS	1	15
a41566ec-a778-4a78-9373-68b0b078480f	What does the acronym GUI stand for?	Graphical User Interface	General User Interface	Graphic User Interface	General User Interaction	1	1
4358c197-14a2-4831-bf51-8527b0ccc70c	Which of these is a sorting algorithm?	Heap Sort	Binary Search	Breadth-First Search	Depth-First Search	1	2
db7abea1-540b-4ed3-b9ef-654f6ff60edc	What is a pointer in C++?	A variable that stores memory addresses	A type of data structure	A method for handling errors	A keyword for defining constants	1	3
c994d2a7-16b0-4c43-b000-df5ebe5176ff	Which data structure is best suited for implementing a LIFO stack?	Array	Queue	Linked List	Heap	3	4
d2b66194-952f-4d60-b2cc-4fb500f8f6b7	What is the main purpose of a destructor in C++?	Release resources	Initialize objects	Allocate memory	Handle exceptions	1	5
758615cf-5245-4100-a5aa-46f827ab7de0	What is the purpose of the 'yield' keyword in Python?	Return a generator object	Define a constant	Create a new thread	Handle exceptions	1	6
41daa847-f381-4938-ae74-e72ca345a259	Which of these is not a common SQL database?	MongoDB	PostgreSQL	MySQL	Oracle	1	7
10fe28e5-b6c0-4563-889d-6aefa12394e3	What is the primary advantage of using a virtual machine?	Isolation of applications	Increased storage capacity	Faster computation	Direct hardware access	1	8
56e9295b-727c-4e5d-a948-44cc85e075e0	Which sorting algorithm has the best average-case time complexity?	Merge Sort	Bubble Sort	Quick Sort	Insertion Sort	1	9
7c11a983-d52b-4d80-9d0f-a057147a838a	What is the purpose of a thread in programming?	Execute tasks concurrently	Store data	Handle user input	Manage memory	1	10
d4fac51e-c6aa-4246-8ba5-ecf5bae9fe35	Which protocol is used to retrieve web pages?	HTTP	FTP	SMTP	POP3	1	11
76e08ced-f30c-498b-9e51-ee9177f190f7	What does the acronym HTML stand for?	HyperText Markup Language	HyperText Management Language	HyperText Markup Library	HyperText Media Language	1	12
2130d614-f54e-452d-8a24-ae62a1982c98	Which data structure allows efficient insertion and deletion at both ends?	Queue	Stack	Deque	Linked List	3	13
81ff390e-3e8d-460c-b491-d941fcb267d4	What is a hash table?	A data structure that uses a hash function for indexing	A method for sorting data	A type of search algorithm	A technique for encrypting data	1	14
c5fc8eb5-1678-4d9e-97b6-d5a74c7163ae	What is the purpose of garbage collection in Java?	Automatic memory management	Data encryption	Error handling	Database indexing	1	15
b1995486-1c9a-4a47-b76b-407fdd2959d8	Which of these is a feature of SQL databases?	ACID compliance	Object-oriented design	Event-driven programming	Concurrency control	1	1
f20d1539-a3f4-4b1d-bc2b-d14ee1afa106	What does the acronym REST stand for?	Representational State Transfer	Resource State Transfer	Remote State Transfer	Read-Write State Transfer	1	2
\.


--
-- Data for Name: rounds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rounds (round_num) FROM stdin;
1
2
3
4
\.


--
-- Data for Name: user_rounds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_rounds (user_id, round_num, entered_at, submitted) FROM stdin;
3fcf0fa5-ea9c-4b9d-8d99-55175637b573	1	2024-08-15 14:05:40.558324	f
0c040bf3-613b-453e-8395-d4e22cd37dd0	1	2024-08-15 14:05:40.558324	f
9439b071-cd92-4a85-b492-a7eaad8d48cd	1	2024-08-15 14:05:40.558324	f
c8403bd6-ebbb-41f7-b232-1542fdc50bfd	1	2024-08-15 14:05:40.558324	f
132f91ff-e426-4ef8-a18a-a88fb2ed0472	1	2024-08-15 14:05:40.558324	f
b0fc951e-cecf-4f8b-a971-a3041560cc2c	1	2024-08-15 14:05:40.558324	f
43c2c4ba-38ef-4060-bde3-dfc8bed814d1	1	2024-08-15 14:05:40.558324	f
a76084e2-6c59-40bd-ac66-781740b11ee4	1	2024-08-15 14:05:40.558324	f
90e3c6f3-43bc-4464-9ef4-fe87257de68d	1	2024-08-15 14:05:40.558324	f
15c050ca-4244-4318-b262-989b9fd6c591	1	2024-08-15 14:05:40.558324	f
4635beff-63ef-4370-83d1-4cc98c43c58d	1	2024-08-15 14:05:40.558324	f
cbfdf7a9-a076-4f7d-a94a-8e2e5964e6d5	1	2024-08-15 14:05:40.558324	f
27979cb0-1b73-4e65-9523-231e38c185a0	1	2024-08-15 14:05:40.558324	f
8d732863-fc7a-43e9-8102-adb90c3e0800	1	2024-08-15 14:05:40.558324	f
eadf82d8-61d1-4767-890f-4e76b33ae342	1	2024-08-15 14:05:40.558324	f
b27eb79a-97c4-4103-a399-66d528e63e62	1	2024-08-15 14:05:40.558324	f
949a382f-0bac-4cf9-9a0f-aeb33ea37328	1	2024-08-15 14:05:40.558324	f
839b756c-143e-4c60-8232-794a6a8d57aa	1	2024-08-15 14:05:40.558324	f
c4f2365f-1323-4c2f-8b3b-840f1f07f1dd	1	2024-08-15 14:05:40.558324	f
5f1adcaf-9836-48e9-b003-54981b1112cc	1	2024-08-15 14:05:40.558324	f
7d000ba8-ce5d-4441-aadd-bbe99d94b7b9	1	2024-08-15 14:05:40.558324	f
50ddf17a-490e-425c-b406-99456392e9e1	1	2024-08-15 14:05:40.558324	f
87ff6a06-1d0b-4006-9c22-a5808014c7ac	1	2024-08-15 14:05:40.558324	f
616e0893-388c-473f-b5cc-df803242e6fb	1	2024-08-15 14:05:40.558324	f
7e01c64c-ddbf-4aa9-98fa-38223bc37ead	1	2024-08-15 14:05:40.558324	f
59c130d1-f386-463e-ae7f-4e36771d3b51	1	2024-08-15 14:05:40.558324	f
8348c298-0ea7-4a4a-8b43-aa3d7da3de2d	1	2024-08-15 14:05:40.558324	f
4fe16b5e-86ad-4e22-846b-c1217900e20a	1	2024-08-15 14:05:40.558324	f
08c64cf9-a684-42c4-9452-5d895e90957c	1	2024-08-15 14:05:40.558324	f
e4ebb98c-c0a1-4923-9ba2-f9aba4ca6b98	1	2024-08-15 14:05:40.558324	f
f7baaa5a-50c8-4b71-aacd-2259243470cb	1	2024-08-15 14:05:40.558324	f
f37b5add-b32b-4c0f-8311-2bfa58f744a3	1	2024-08-15 14:05:40.558324	f
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, team_name, key) FROM stdin;
3fcf0fa5-ea9c-4b9d-8d99-55175637b573	Naruto Uzumaki	fj3kd84hs92a
0c040bf3-613b-453e-8395-d4e22cd37dd0	Sasuke Uchiha	m2jf7sl8a3dc
9439b071-cd92-4a85-b492-a7eaad8d48cd	Goku	93nskf72ndlf
c8403bd6-ebbb-41f7-b232-1542fdc50bfd	Vegeta	p9fn8k3sld2a
132f91ff-e426-4ef8-a18a-a88fb2ed0472	Luffy	jf2lk8n30sd7
b0fc951e-cecf-4f8b-a971-a3041560cc2c	Zoro	hs8kd9f2j4sm
43c2c4ba-38ef-4060-bde3-dfc8bed814d1	Ichigo Kurosaki	v8k7djs3l9fn
a76084e2-6c59-40bd-ac66-781740b11ee4	Rukia Kuchiki	7d8lsf2m90fk
90e3c6f3-43bc-4464-9ef4-fe87257de68d	Edward Elric	js8f3k9mn7dl
15c050ca-4244-4318-b262-989b9fd6c591	Alphonse Elric	4dkf8j2ms93a
4635beff-63ef-4370-83d1-4cc98c43c58d	Light Yagami	v7dkl93js82a
cbfdf7a9-a076-4f7d-a94a-8e2e5964e6d5	L Lawliet	9fj2ksm5l8a3
27979cb0-1b73-4e65-9523-231e38c185a0	Eren Yeager	2kdj7s94lfm8
8d732863-fc7a-43e9-8102-adb90c3e0800	Mikasa Ackerman	js9f2ld7n8k3
eadf82d8-61d1-4767-890f-4e76b33ae342	Levi Ackerman	k8fn7js39adl
b27eb79a-97c4-4103-a399-66d528e63e62	Natsu Dragneel	f2kd83s9lm7a
949a382f-0bac-4cf9-9a0f-aeb33ea37328	Lucy Heartfilia	9dj3kf7s8m2a
839b756c-143e-4c60-8232-794a6a8d57aa	Erza Scarlet	js7k29f8ldm4
c4f2365f-1323-4c2f-8b3b-840f1f07f1dd	Gon Freecss	4djs8f3km92l
5f1adcaf-9836-48e9-b003-54981b1112cc	Killua Zoldyck	k9fn7d8js6ma
7d000ba8-ce5d-4441-aadd-bbe99d94b7b9	Saitama	m3k7djf9ls8a
50ddf17a-490e-425c-b406-99456392e9e1	Genos	8j2kf7s9mdla
87ff6a06-1d0b-4006-9c22-a5808014c7ac	Tanjiro Kamado	4dkf7j2s9mla
616e0893-388c-473f-b5cc-df803242e6fb	Nezuko Kamado	9fj2kd8sm7l3
7e01c64c-ddbf-4aa9-98fa-38223bc37ead	Deku	7dfk29sm83la
59c130d1-f386-463e-ae7f-4e36771d3b51	Katsuki Bakugo	j9f2ks8mld7a
8348c298-0ea7-4a4a-8b43-aa3d7da3de2d	All Might	4ksm8f2dj7la
4fe16b5e-86ad-4e22-846b-c1217900e20a	Itachi Uchiha	f8k2jd7sm9la
08c64cf9-a684-42c4-9452-5d895e90957c	Kakashi Hatake	js9f8k2m7lda
e4ebb98c-c0a1-4923-9ba2-f9aba4ca6b98	Shoto Todoroki	f4kd7s8j9mla
f7baaa5a-50c8-4b71-aacd-2259243470cb	Sakura Haruno	k9fj2d7slm8a
f37b5add-b32b-4c0f-8311-2bfa58f744a3	Hinata Hyuga	8djs9f3k7mla
\.


--
-- Data for Name: winner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.winner (user_id) FROM stdin;
\.


--
-- Name: access_codes access_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_codes
    ADD CONSTRAINT access_codes_pkey PRIMARY KEY (code);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (loc_id);


--
-- Name: hints pk_loc_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hints
    ADD CONSTRAINT pk_loc_id PRIMARY KEY (loc_id);


--
-- Name: location_count pk_loc_id_count; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_count
    ADD CONSTRAINT pk_loc_id_count PRIMARY KEY (loc_id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (que_id);


--
-- Name: rounds rounds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rounds
    ADD CONSTRAINT rounds_pkey PRIMARY KEY (round_num);


--
-- Name: users unique_team_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT unique_team_name UNIQUE (team_name);


--
-- Name: location_users user_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_users
    ADD CONSTRAINT user_unique UNIQUE (user_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_id_idx ON public.users USING btree (user_id);


--
-- Name: users_id_idx1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_id_idx1 ON public.users USING btree (user_id);


--
-- Name: hints hints_loc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hints
    ADD CONSTRAINT hints_loc_id_fkey FOREIGN KEY (loc_id) REFERENCES public.locations(loc_id);


--
-- Name: location_count loc_count_loc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_count
    ADD CONSTRAINT loc_count_loc_id_fkey FOREIGN KEY (loc_id) REFERENCES public.locations(loc_id);


--
-- Name: questions loc_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT loc_id_fk FOREIGN KEY (loc_id) REFERENCES public.locations(loc_id);


--
-- Name: location_users loc_id_pk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_users
    ADD CONSTRAINT loc_id_pk FOREIGN KEY (loc_id) REFERENCES public.locations(loc_id);


--
-- Name: access_codes loc_id_pk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_codes
    ADD CONSTRAINT loc_id_pk FOREIGN KEY (loc_id) REFERENCES public.locations(loc_id);


--
-- Name: location_next location_next_loc_next_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_next
    ADD CONSTRAINT location_next_loc_next_fkey FOREIGN KEY (loc_next) REFERENCES public.locations(loc_id);


--
-- Name: location_next location_next_loc_now_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_next
    ADD CONSTRAINT location_next_loc_now_fkey FOREIGN KEY (loc_now) REFERENCES public.locations(loc_id);


--
-- Name: user_rounds round_num_constraint; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_rounds
    ADD CONSTRAINT round_num_constraint FOREIGN KEY (round_num) REFERENCES public.rounds(round_num);


--
-- Name: locations round_num_constraint; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT round_num_constraint FOREIGN KEY (round_num) REFERENCES public.rounds(round_num);


--
-- Name: location_users u_id_constraint; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_users
    ADD CONSTRAINT u_id_constraint FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: user_rounds user_rounds_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_rounds
    ADD CONSTRAINT user_rounds_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: winner winner_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.winner
    ADD CONSTRAINT winner_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

