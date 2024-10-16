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
    code text DEFAULT public.generate_random_string(24) NOT NULL,
    loc_id integer
);


ALTER TABLE public.access_codes OWNER TO postgres;

--
-- Name: eliminated; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eliminated (
    user_id uuid
);


ALTER TABLE public.eliminated OWNER TO postgres;

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
    round_num integer,
    CONSTRAINT questions_correct_check CHECK (((correct >= 1) AND (correct <= 4)))
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: rounds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rounds (
    round_num integer DEFAULT 1 NOT NULL,
    duration integer
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
599xyfiysivcm06craym6ytw	1
go40xkfjpfh20615nvro9jrn	2
umgo8r98cf42yn2t3304c05m	3
1zrbo2mlfbozbkk94d3ufm22	4
u0ycnwopl1swhxu7wu9k0a3u	5
2xx5lr26tlrg1u6p3nyijqs5	6
bey6bzd8xeat4enxqbm60l0z	7
ycwk1o9vn58urwh97mib8hzv	8
2sbrdbd0wz8z2hdxsex8huk4	10
4rx2kt5cgmvtt64ucr8yu0w4	11
p3q16q5ycz7ch5zqtkuhggql	12
qvt7w32et1qfo3qpj9lr38f2	13
zheiv93ib33rwnz4v3z5awgg	14
mgafnsz4vcghm1phi4lcrkdq	15
7qk3q2rv05ez38spvp7h62oh	16
jlm3tpf2m3e41z02vz6ai5qf	17
00jqza0uxn9nr9qf29siu86o	18
tygv88quysg6ebstqbbuepow	19
wyq0bf2kr5ha339wh95b9gb2	20
g5dk5shjv5nxtyeuxut43w02	21
2z9maqc9yy89s7eqzud0mwzq	22
txyjcp6a8vo0d9s7q5tabjs2	23
m450ze6i8aue083hny7dw5gs	9
\.


--
-- Data for Name: eliminated; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eliminated (user_id) FROM stdin;
\.


--
-- Data for Name: hints; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hints (loc_id, hint) FROM stdin;
6	An art carved out of a single stone. Miniature at its best, near the fountain I rest.
10	An art carved out of a single stone. Miniature at its best, near the fountain I rest.
2	Smoking is harmful, but i smoke to run. \nसफ़र with me is so fun.चल छैयां छैयां छैयां!\n\n
14	Smoking is harmful, but i smoke to run. \nसफ़र with me is so fun.चल छैयां छैयां छैयां!\n\n
4	lakdi ki kathi, lakdi ka chakka, chakka chalta khet me dhundo isko campus me.
15	lakdi ki kathi, lakdi ka chakka, chakka chalta khet me dhundo isko campus me.
1	On the grounds of campus, their presence is known, hint is between two of them, find on your own,\nWhere symbols of non violence and pride stand still, side by side,\nOne shows the way of ahimsa, the other marks a historic guide.
11	On the grounds of campus, their presence is known, hint is between two of them, find on your own,\nWhere symbols of non violence and pride stand still, side by side,\nOne shows the way of ahimsa, the other marks a historic guide.
21	I got 12 wheels, but I am not a truck. I am on top. Yeah, I am stuck! Let us see whether you can find me or not, best of luck!
17	Rasta Jo jaaye manjil se aage, milte ho jaha TEEN RAASTE aake. Waha h koi jo kar raha h HUSTLE. Wahi, jiski speciality he MUSCLE!
22	Bunk karne mere paas aao na. Band ho gaya hun to kya, phir bhi hariyali dekhne mere yaha baith jao na.
19	A serene figure, bathed in golden light,\nA symbol of peace, a guiding sight.\nWith a peaceful gaze and message of peace,\nHe said, "Be your own light!"
8	jinke makaan sheeshe ke hote hai, voh makaan ke andar gadi park karte hai.
13	jinke makaan sheeshe ke hote hai, voh makaan ke andar gadi park karte hai.
5	Ye shaqs nahi tha aam, yahi se aya tha college ka naam. Jahan shankh hai bade, vahi ye khade.
16	Ye shaqs nahi tha aam, yahi se aya tha college ka naam. Jahan shankh hai bade, vahi ye khade.
20	The game is 90 minutes long. If you are still like a statue the ball will be gone. If you aim where I look, you have already won!
7	kadam ek dhatu ka jispe likha hai gyan, usi ke peeche milega paheli ka javab ye baat tu pehchaan.
12	kadam ek dhatu ka jispe likha hai gyan, usi ke peeche milega paheli ka javab ye baat tu pehchaan.
23	A block of seven, where heights ascend, seek the place where your journey will end. find your next clue where vehicles walk, Not near the base, but just below the top. Pillars in middle hold your hint,with your destiny in the print 
18	Egypt se aya hu, Jamakar baitha hu thaat.\nRang hai safed, judwaa mere sath.\nMilunga wahi jaha bagicha mere pehle aur Siddharth mere baad
3	Main gate se andar aate hi, kuch duur chalte hi, saadagi mey bhi hai fashion, dhundo iss hint ka connection
9	Main gate se andar aate hi, kuch duur chalte hi, saadagi mey bhi hai fashion, dhundo iss hint ka connection
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
10	0
11	0
12	0
13	0
14	0
15	0
16	0
17	0
18	0
19	0
20	0
21	0
22	0
23	0
9	0
\.


--
-- Data for Name: location_next; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_next (loc_now, loc_next) FROM stdin;
1	9
2	10
3	11
4	12
5	13
6	14
7	15
8	16
9	17
10	17
11	18
12	18
13	19
14	19
15	20
16	20
17	21
18	21
19	22
20	22
21	23
22	23
\.


--
-- Data for Name: location_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_users (user_id, loc_id) FROM stdin;
08c64cf9-a684-42c4-9452-5d895e90957c	1
0c040bf3-613b-453e-8395-d4e22cd37dd0	1
132f91ff-e426-4ef8-a18a-a88fb2ed0472	1
15c050ca-4244-4318-b262-989b9fd6c591	1
27979cb0-1b73-4e65-9523-231e38c185a0	2
3fcf0fa5-ea9c-4b9d-8d99-55175637b573	2
43c2c4ba-38ef-4060-bde3-dfc8bed814d1	2
4635beff-63ef-4370-83d1-4cc98c43c58d	2
4fe16b5e-86ad-4e22-846b-c1217900e20a	3
50ddf17a-490e-425c-b406-99456392e9e1	3
59c130d1-f386-463e-ae7f-4e36771d3b51	3
5f1adcaf-9836-48e9-b003-54981b1112cc	3
616e0893-388c-473f-b5cc-df803242e6fb	4
7d000ba8-ce5d-4441-aadd-bbe99d94b7b9	4
7e01c64c-ddbf-4aa9-98fa-38223bc37ead	4
8348c298-0ea7-4a4a-8b43-aa3d7da3de2d	4
839b756c-143e-4c60-8232-794a6a8d57aa	5
87ff6a06-1d0b-4006-9c22-a5808014c7ac	5
8d732863-fc7a-43e9-8102-adb90c3e0800	5
90e3c6f3-43bc-4464-9ef4-fe87257de68d	5
9439b071-cd92-4a85-b492-a7eaad8d48cd	6
949a382f-0bac-4cf9-9a0f-aeb33ea37328	6
a76084e2-6c59-40bd-ac66-781740b11ee4	6
b0fc951e-cecf-4f8b-a971-a3041560cc2c	6
b27eb79a-97c4-4103-a399-66d528e63e62	7
c4f2365f-1323-4c2f-8b3b-840f1f07f1dd	7
c8403bd6-ebbb-41f7-b232-1542fdc50bfd	7
cbfdf7a9-a076-4f7d-a94a-8e2e5964e6d5	7
e4ebb98c-c0a1-4923-9ba2-f9aba4ca6b98	8
eadf82d8-61d1-4767-890f-4e76b33ae342	8
f37b5add-b32b-4c0f-8311-2bfa58f744a3	8
f7baaa5a-50c8-4b71-aacd-2259243470cb	8
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (loc_name, round_num, loc_id) FROM stdin;
Gandhi Statue	1	1
Green Train	1	2
Textile Showroom	1	3
Bullock Cart	1	4
Shell Fountain	1	5
Ajanta Caves	1	6
Old Tree	1	7
Automobile Workshop	1	8
Ajanta Caves	2	10
Gandhi Statue	2	11
Old Tree	2	12
Automobile Workshop	2	13
Green Train	2	14
Bullock Cart	2	15
Shell Fountain	2	16
Carving Statue	3	17
BJP Statue	3	18
Buddha Statue	3	19
Football Statue	3	20
Car Fountain	4	21
Chhota Canteen	4	22
JNEC Parking	5	23
Textile Showroom	2	9
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questions (que_id, question, option1, option2, option3, option4, correct, round_num) FROM stdin;
3cd9d2c9-e6d1-44ce-bf9f-3eace65589c1	What is the value of the postfix expression 8 11 7 4 + – *?	0	-33	33	-9	1	2
f341360b-dbf1-4254-8bef-c709779d9d4e	What is the purpose of the SQL query shown in the snippet? `SELECT * FROM employees WHERE department = 'Sales';`	Insert new employee records	Update existing employee records	Retrieve employee records from the 'Sales' department	Delete employee records from the 'Sales' department	3	2
d00f390a-58f8-4ee9-8be1-1a3fac5c201a	Which of the following is NOT a type of computer memory?	CPU	ROM	RAM	Cache	1	1
02d5a3e5-472a-4846-9f8d-fc250bd0359c	Given the decimal number 15, how can we represent this number in binary form?	1111	1100	1010	1001	1	1
d5c20334-e9e3-4210-a432-ebc140f5071a	1) git add 2) git commit 3) git _______?	pull	push	pullout	clone	2	1
6580f59e-3f2f-4657-9f92-b8eba557203f	Which of the following is NOT a high-level programming language?	Python	Assembly	Java	C++	2	1
6294e12d-b972-4b0e-ba77-006d8fc9ea09	How do you delete everything in a directory in Linux?	rm -rf ./	rm -d ./	rm --all	rm --all ./	1	1
65d72c23-8d4f-4a65-95aa-ac37e0dd7349	What is the process of converting plaintext into ciphertext called?	Decryption	Encryption	Hashing	Encoding	2	1
82b7e98c-114b-4be3-a434-50e42437ab3c	Which technology is used for wireless communication over *very* short distances?	Bluetooth	Wifi	Cellular	Satellite	1	1
3203bc1f-e211-4a4c-a88a-3ff8a8567959	What will be the output of the following Python code: ```print(15 // 4)```	3	3.75	4	3.5	1	1
e3dc6bca-51b9-489d-980c-2ca1f3dac953	Which of these is not a searching algorithm?	DFS	A-Star	Dijkstra	Kadane's Algorithm	4	1
f7994ed1-bf01-4b04-a529-a9f8336190c9	What is the core component of an Artificial Neural Network?	Synapse	Dendrite	Neuron	Axon	3	1
16c804a3-0dc3-4c0c-89af-dcf1249ac656	Which data structure is best suited for implementing a priority queue?	Array	Linked List	Stack	Heap	4	1
2c5b76d7-6cad-45ed-8e7c-f4b139c03bf0	What is the purpose of a hash function in a hash table?	To sort the data	To map keys to indices	To encrypt the data	To compress the data	2	1
c4fb528d-fd84-4b6a-956f-f83934119ece	In a binary search tree, which traversal method produces a sorted output?	Inorder	Preorder	Postorder	Any one of the above	1	1
631be8e7-b71f-40a1-b352-54f515021b4f	Which of these is a cloud computing service model?	Infrastructure as a Service (IaaS)	Platform as a Service (PaaS)	Software as a Service (SaaS)	All of the above	4	1
b4428d5c-19c6-42a7-82d4-6fee2d9bb3e2	Which of the following is a divide-and-conquer algorithm?	Bubble Sort	Selection Sort	Merge Sort	Insertion Sort	3	1
d2201163-cb43-4810-97b4-3c25981e3310	In a relational database, what is the purpose of a primary key?	define the data type of a table and order table sequentially	Uniquely identify each record in a table, so that no two rows have the same primary key. Also primary keys can't be NULL	A primary key is a special key that is used to group records together in a table, often used for sorting and filtering data efficiently.	An optional field in a table used to create a relationship between two or more tables in the database.	2	3
e44cb8e9-e34d-4d2d-ad16-c5b937fd0276	Which of the following protocols is used for secure communication over an untrusted network like the Internet?	HTTP	FTP	SSH	Telnet	3	3
82e95da3-fcb7-49eb-8955-06a556ee7ddd	What does the following list comprehension in Python yield: `[i for i in range(10)]`	[-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]	[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]	[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]	3	1
2497c4f1-dfc7-4bd4-8e00-f1b07b78a14d	Which of the following is not a feature of Object-Oriented Programming (OOP)?	Encapsulation	Inheritance	Polymorphism	Recursion	4	1
437842bc-31dc-4cc6-90eb-452909544030	In SQL, which of the following commands is used to remove a table from a database?	DELETE	DROP	REMOVE	ERASE	2	1
8dc63b27-c118-4c55-8918-d69cecfbb242	The minimum number of stacks needed to implement a queue is	3	1	2	4	3	1
1a7ee7a1-ce88-466d-86bc-78672c80c118	In the context of version control, what does "Git" primarily manage?	Database transactions	File versions	Networking protocols	Web sessions	2	1
fdd5e8d2-e462-4435-86c2-6c22cb03baa5	What language did WhatsApp use in their launching phase to scale to millions of users with a small team of engineers?	Erlang	C++	Java	Python	1	0
c2aeda89-8e75-4548-9e21-fe6ba572410a	What is the output of this list comprehension? ```[char for char in "Python" if char.isupper()]```	["P", "y", "t", "h", "o", "n"], 	["P", "y", "t", "h"]	["P"]	["P", "n"]	3	0
760be1b0-56d1-4dec-9ac8-745c8156bd50	Which of the following is a key characteristic of a relational database?	 Hierarchical data structure	Data is organized in tables (relations)	Network data model	 Data is stored as objects	2	0
2e3f402f-8443-4682-97b1-ac31fa14cd34	Which of the following statements is true about Java?	Java supports multiple inheritance using classes.	Java uses pointers for memory management.	Java is platform-independent due to the JVM.	Java allows operator overloading.	3	0
9c2b859e-afe4-4b9d-9763-4074fc9f63f8	In Java, which of the following is used to handle exceptions?	if-else	switch-case	try-catch	do while loop	3	0
9f96af12-83e3-4935-9985-4e74c5f8445a	Which of the following is an advantage of a linked list over an array?	Random access of elements	Fixed size	Better cache locality	Dynamic size	4	0
35b73e1a-2b05-4bb2-adc2-1b3b1c24b00a	What is the purpose of exception handling in programming?	To manage and respond to runtime errors.	To optimize code performance.	To log function calls and results.	To predefine input values for functions.	1	0
41a50d93-e075-4db8-90ba-b1361c98baaa	 In Python, which of the following is not a valid data type?	List	Tuple	LinkedList	Integer	3	0
4abe6502-2c56-41e8-8b7e-75e72fdbe5ca	VST stands for:	Virtualisation Software Technology	Visual SaaS Template	Virtual Studio Technology	Vacant Swapping Technique	3	0
b89076f5-56d8-4189-a033-7a4ee6180378	 What is a "data structure" in programming?	A collection of functions for data transformation.	Organizing and storing data for efficient access and modification.	An algorithm for processing data.	Syntax for declaring variables and constants.	2	0
ba642100-dc70-46ea-ae04-7ee9906ca76d	Which of the following is a valid declaration of a pointer in C?	int ptr;	int *ptr;	int &ptr;	pointer int ptr;	2	0
aa22c0df-f8db-400e-9351-ee1fac082147	In Java, which method is used to start a thread?	run()	start()	init()	execute()	2	0
7e8d7a31-1752-46df-9f12-bedc7d08d012	Which of the following code has the fastest execution time?	O(nlog n)	O(n)	O(n!)	O(log n)	4	0
917f09ca-0f24-4a0e-ada0-7d9edcf5b12b	What is "recursion" in programming?	Optimizing function execution through loops.	Predefining input values for functions.	A function calling itself to solve smaller sub-problems.	Incrementing and Repeated execution of code until a condition is met.	3	0
62550331-83bc-403f-a82c-de15a02a58bf	What does ACID stand for in the context of databases?	Atomicity, Consistency, Isolation, Durability	 Atomicity, Concurrency, Integrity, Durability	Aggregation, Consistency, Isolation, Durability	Abstraction, Consistency, Isolation, Data	1	0
75870391-37c0-490a-95b4-fa6a8a662d14	How do you execute a python file?	`run <filename>.py` in the terminal.	`execute <filename>.py` in the shell.	`python <filename>.py` in the command line.	`python3 run <filename>.py` in the command line.	3	0
56bf713e-566c-4e03-9d96-b828d0e51168	What is the time complexity of binary search in a sorted array?	O(n)	O(log n)	O(n log n)	O(n²)	2	0
408de064-39a3-4b49-a972-6574eb152339	What does BFS stand for?	Binary-First Search	Breadth-First Search	Binary-Finding System	Breadth-Finding Strategy	2	0
4119de89-a95e-4515-9232-7256a32c7b79	What does SQL stand for?	Standard Query Language	System Query Language	Structured Query Language	System Query Language	3	0
aec849c4-552f-4cdd-9cdd-68a84dc7f8b1	In a relational database, which constraint ensures that a column cannot have NULL values?	FOREIGN KEY	UNIQUE	NOT NULL	DEFAULT	3	0
54b7e2be-5989-40b8-a2bb-9734609b6836	How many pointers at max are necessarily changed for the insertion in a singly linked list?	1	3	0	2	4	2
99be7db2-9bbb-4c9d-972a-c465a007fd01	The type of pointer used to point to the address of the next element in a singly linked list?	Pointer to Char	Pointer to Int	Pointer to Node	Pointer to String	3	2
da4dabc8-6206-4b44-a56f-2762c7ecb41e	Which of the following is not the application of stack?	Data Transfer between two asynchronous process	Compiler Syntax Analyzer	Tracking of local variables at run time	A parentheses balancing program	1	2
88247eae-395c-43bd-bd13-9ab046016e30	What is a null pointer reference? (Hint: CrowdStrike suffered a lot because of this)	Pointer to a memory address that has been deallocated	A default variable called "null" to initialise a constructor in C++.	A pointer that has been declared but not initialised	A pointer that could be used to reference more than one locations at the same time.	1	2
158905be-9ee4-43a6-8111-c0069a9f92fb	Which of these is a postfix expression?	a+c-d	ab+ cd- *	ab(cd+)- *	*ab-+cde	2	2
62938952-9912-4715-afef-0f2fab418234	Which of These is **NOT** an AWS service?	S3	ABS	RDS	EC2	2	2
265d802a-1937-4106-87f7-7eb8a1fd8c99	Which of These is **NOT** a Page Replacement Algorithm	FIFO	LRU	LIFO	Optimal Page Replacement	3	2
50f6c8b3-2457-4cad-b7f9-6db7791ae43b	Which of the following is a non-preemptive scheduling algorithm?	Round Robin	Shortest First  Job (SFJ)	Priority Scheduling	First-Come, First-Served (FCFS)	4	2
159fd675-be19-4f36-9054-9d8278f9b9db	Which of the following algorithms is specifically used for finding the shortest path in a graph?	Depth-First Search (DFS)	Breadth-First Search (BFS)	Dijkstra’s Algorithm	Heuristic Search	3	2
4caa0a53-44b3-4f70-a2a9-7e0c113f3262	Which of the following sorting algorithms is not stable?	Merge Sort	Bubble Sort	Quick Sort	Insertion Sort	3	2
37f5fd3f-0da5-44df-8d3d-62148f0fc47d	Which SQL keyword is used to remove duplicate records in a query result?	UNIQUE	DELETE	SELECT	DISTINCT	4	2
83884f3e-32fe-40e1-9a92-5b9e7b1bbb15	Which of the following algorithms is NOT used for encryption?	AES	RSA	SHA-256	Blowfish	3	2
807c5bde-2616-44f9-a00b-f3dafc44637e	What is the worst-case time complexity of quicksort?	O(n)	O(log n)	O(n log n)	O(n²)	4	2
cb96f6df-09ba-4294-b86c-5b65c68123c5	What is Bob doing here in the 8th episode of the 2nd season of Stranger Things ![](/assets/bob.png)	Developing a web application for storing passwords	Running away from Demogorgons and brute-forcing a 3-digit password	Running away from Demogorgons and brute-forcing a 4-digit password	Training a model for classifying Demogorgons	3	2
4540f31d-d8f3-4776-8639-29c9d2732299	In object-oriented programming, what is the concept of polymorphism?	Same Parameter Name, different Constructor 	Same Constructor Name, different Parameter	Same Parameters Name, different function 	Same Function Name, different Parameters	4	2
2c5c5c9e-9549-49b6-8844-d61f8ef06128	What does the term "latency" refer to in networking?	The amount of data that can be transferred in a given time	The time taken for a data packet to travel from source to destination	The number of errors per unit of time	The frequency of data collisions	2	2
e9173190-e37f-4089-b3b0-6a6470bf0614	Which of the following algorithms is typically used in the TCP protocol to prevent network congestion?	RSA	Dijkstra's Algorithm	Sliding Window Protocol	Slow Start	4	2
d4657c6d-93a4-4df0-b40c-f0be3ad2449e	You are tasked with optimizing the performance of a web application. Which technique involves storing frequently accessed data in a store, reducing the need to fetch it from the original source and potentially improving response times?	Load Balancing	Compression	Minification	Caching	4	3
bb574d85-3298-4f6d-8cd4-f2f21c870afa	In operating systems, what is the name of the memory management technique that divides memory into fixed-size blocks called pages?	Segmentation	Swapping	Paging	Thrashing	3	3
ac2eb4b3-c117-49b1-9a3e-1a638527e95e	Consider a scenario where you need to design a fault-tolerant system that can continue operating even if some of its components fail. Which architectural pattern involves replicating critical components and distributing them across multiple nodes to ensure high availability and resilience?	Microservices Architecture	Monolithic Architecture	Distributed Architecture	Layered Architecture	3	3
82e27c56-63c2-4e91-b666-d4368caeee2f	Which of the following is a type of cyber attack that involves tricking users into revealing sensitive information?	Malware	Ransomware	Phishing	Denial of Service (DoS)	3	3
36bc4d89-f950-44fa-9fda-6071ab7ffe40	Which of these is **NOT** a method to exit the Vim text editor?	:q!	ZZ	ZQ	:w	4	3
a1bd6ebc-b9f1-4238-8ad4-75e7a2c95c5e	What is the purpose of load balancing in system design?	To encrypt data	To compress data for faster transmission	To cache frequently accessed data	To distribute traffic across multiple servers	4	3
6c9caa9a-ba98-4c99-ae87-37517f8a57cf	Which of these HTTP methods should not be used while sending a request body?	PUT	GET	POST	PATCH	2	3
f5664de0-a8ea-4c37-aca5-cdf2216c258b	Which of these is not a defining feature of Redis?	Multithreading	In-memory caching	Pub/sub	Support for linear data structures	1	3
f67b2f1b-4ed7-48c4-b0b5-ca9192ec5633	What would be the optimal time complexity for generating Fibonacci series?	O(logn)	O(n)	O(2^n)	O(n^2)	1	3
b6189127-96f8-4634-8648-010a64ca0d8b	Which of the following HTTP status codes indicates that the request was successful and the server returned the requested data?	200	301	404	500	1	3
1c9fe053-3990-49e7-825b-27231ff6134b	What is the output of the following C++ code?\n```\n#include <iostream>\nusing namespace std;\n\nint main() {\n    int a = 10;\n    int b = a++ + ++a;\n    cout << b;\n    return 0;\n}```	21	20	22	19	3	3
b9234578-a302-4e83-bf4e-0f70a8e029d7	What is the output of the following Python code snippet?\n```\nx = [1, 2, 3, 4]\ny = x.copy()\ny.append(5)\nprint(x, y)\n```	`[1, 2, 3, 4] [1, 2, 3, 4, 5]`	`[1, 2, 3, 4] [1, 2, 3, 4]`	`[1, 2, 3, 4, 5] [1, 2, 3, 4, 5]`	Error: The `copy()` method is not valid for lists.	1	3
7d0d1c8d-5727-42e8-8e37-4a03efc9d214	What programming concept is demonstrated in the provided code snippet?\n```\ndef calculate_factorial(n):\n    if n == 0:\n        return 1\n    else:\n        return n * calculate_factorial(n - 1)\n```	Iterative	 Recursion	Polymorphism	Encapsulation	2	3
0136cc4a-a09f-4cd3-8416-0789a870f863	What is the output of the following code snippet: \n```\nint x = 5; \nint y = x++ + ++x; \nstd::cout << y;\n```	10	12	11	13	2	3
2b157365-47fb-4cba-93b1-4159ffbd0cf9	What will be the output of the following C++ code?\n```\n#include <iostream>\nusing namespace std;\n\nint main() {\n    int a = 5, b = 10, c = 15;\n    int x = (a > b) ? (b > c) ? b : c : (a > c) ? a : c;\n    cout << x;\n    return 0;\n}\n```	5	10	15	Compilation error	3	3
ff3d0c0c-a261-43b4-a942-5c555b72832d	What programming concept is demonstrated in the following Python code snippet?\n```\nclass Animal:\n    def make_sound(self):\n        print("Animal sound")\n\nclass Mammal(Animal):\n    def has_fur(self):\n        print("Has fur")\n\nclass Dog(Mammal):\n    def bark(self):\n        print("Woof!")\n```	Multilevel Inheritance	Multiple Inheritance	Hierarchical Inheritance	Single Inheritance	1	3
458e8b39-9647-4ee8-a84c-5914ed2666a5	What is a candidate key in relational databases?	Any group of keys that can be a candidate for uniquely identifying the tuple	It has information about the candidates in a table	The minimal group of keys that can be candidate for uniquely identifying the tuple	All the attributes in the table barring the primary key	3	3
9fe76a7a-7766-4282-aea9-fb9c26da8e6a	A Caesar Cipher is an encryption technique that was famously used by, you guessed it right, Julius Caesar! In this technique, you shift the input characters 3 places forward. "A" becomes "D" ("A"->"B"->"C"->"D"), "G" becomes "J" ("G"->"H"->"I"->"J") and "Z" becomes "C" ("Z"->"A"->"B"->"C") due to rotation. Thus, "TECH HUNT" would become "WHFK KXQW". Find the Caesar Cipher for the GFG motto. Make sure only Julius Caesar can decode the glorious motto of GFG! (Hint: You may search for the GFG motto!)	OHDEQ, SUDFGLFH, NQG HKFRO	OHDUQ, SUDFWLFH, DQG HAFHO	YRNEA, CENPGVPR, NAQ RKPRY	YHNUA, SEDPWVFR, DAG RAPHY	2	4
f2972db1-1ed8-4c1d-9f9a-e3f66c40ba29	(2^2^2^2^2^2^2^2^2^2^2^2^2^2^2^2) mod 10 is? (a^b is read as "a raised to the power of b")	3	8	6	2	3	4
3c502fa6-a020-43ac-9c0d-4eebe9a44ee8	There are 23 people, labelled from 1 to 23, in a circle. '1' has a knife (chaku) and kills the person next to him (2) and passes the knife to 3, 3 kills 4 and gives the knife to 5. This carries on until there is only one person alive (by god's grace).	1	15	8	23	4	4
7d8c1d22-fccc-4d0f-a8f6-9003dbe6e5fe	Given the numbers [999, 1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018, 1019, 1020], find the maximum number of times you will have to remove sets of any 3 numbers such that their greatest common divisor is 1 until there are no such sets remaining.	3	4	5	6	3	4
e9c5b19f-33ee-42ed-809d-04178ebaa518	You are given a list of integers where every element appears twice except for one. You need to find that single element in the most efficient way. Which of the following algorithms would you choose?	Sort the array and compare adjacent elements.	Use a hash map to count the frequency of each element.	Use the XOR bitwise operation on all elements.	Iterate through the list comparing each element with every other element. give answer	3	4
dfdf30e5-d2eb-438d-9aa5-5d46e36eb32e	How many distinct 9-digit numbers can be formed using the digits 1, 1, 2, 2, 2, 3, 3, 4, 4 such that the two 1’s are never adjacent?	7560	45360	90720	15120	2	4
c1c91f61-58d2-4bab-b29a-5676fc7eb950	You are in a room with 3 light switches, each of which controls one of three bulbs in another room. You cannot see the bulbs from where the switches are. You can only enter the room with the bulbs once. How do you determine which switch controls which bulb?	Turn on all the switches and then turn off one, check which bulb is still warm.	Turn on one switch, wait, then turn it off. Turn on the second switch and enter the room.	Turn on one switch for a few minutes, then turn it off. Turn on another and go into the room.	Turn on two switches, and go to the other room to check the bulbs' positions.	3	4
d212b249-f6d7-4c62-ab72-975c6ebeb64b	What is the output of the following Java code?\n```\npublic class Main{\n     public static void main(String []args){\n        int x = 10;\n        int y = 5;\n        int z = (x > y) ? x : y;\n        System.out.println(z);\n     }\n}\n```	10	5	15	syntax error	1	2
81f6694a-6bb2-4d41-8625-c8af117500a0	In Python, what will be the output of the following code snippet?\n```\ndef func(x, y=[]):\n    y.append(x)\n    return y\n\nprint(func(1))\nprint(func(2))\n```	[1] [2]	[1] [1, 2]	[1, 2] [1, 2]	[1, 2] [2]	2	3
e532acff-e801-4cb1-afd5-69b8bbdb9029	What is the output of the following C code?\n#include <stdio.h>\n```\nint fun(int a) {\n    if(a > 100)\n        return a - 10;\n    else\n        return fun(fun(a + 11));\n}\n\nint main() {\n    printf("%d\\n", fun(95));\n    return 0;\n}\n```	91	100	105	Infinite Recursion	1	4
\.


--
-- Data for Name: rounds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rounds (round_num, duration) FROM stdin;
1	5
2	5
3	5
4	5
5	10
0	5
\.


--
-- Data for Name: user_rounds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_rounds (user_id, round_num, entered_at, submitted) FROM stdin;
3fcf0fa5-ea9c-4b9d-8d99-55175637b573	0	2024-09-07 01:11:57.532217	f
0c040bf3-613b-453e-8395-d4e22cd37dd0	0	2024-09-07 01:11:57.532217	f
9439b071-cd92-4a85-b492-a7eaad8d48cd	0	2024-09-07 01:11:57.532217	f
c8403bd6-ebbb-41f7-b232-1542fdc50bfd	0	2024-09-07 01:11:57.532217	f
132f91ff-e426-4ef8-a18a-a88fb2ed0472	0	2024-09-07 01:11:57.532217	f
b0fc951e-cecf-4f8b-a971-a3041560cc2c	0	2024-09-07 01:11:57.532217	f
43c2c4ba-38ef-4060-bde3-dfc8bed814d1	0	2024-09-07 01:11:57.532217	f
a76084e2-6c59-40bd-ac66-781740b11ee4	0	2024-09-07 01:11:57.532217	f
90e3c6f3-43bc-4464-9ef4-fe87257de68d	0	2024-09-07 01:11:57.532217	f
15c050ca-4244-4318-b262-989b9fd6c591	0	2024-09-07 01:11:57.532217	f
4635beff-63ef-4370-83d1-4cc98c43c58d	0	2024-09-07 01:11:57.532217	f
cbfdf7a9-a076-4f7d-a94a-8e2e5964e6d5	0	2024-09-07 01:11:57.532217	f
27979cb0-1b73-4e65-9523-231e38c185a0	0	2024-09-07 01:11:57.532217	f
8d732863-fc7a-43e9-8102-adb90c3e0800	0	2024-09-07 01:11:57.532217	f
eadf82d8-61d1-4767-890f-4e76b33ae342	0	2024-09-07 01:11:57.532217	f
b27eb79a-97c4-4103-a399-66d528e63e62	0	2024-09-07 01:11:57.532217	f
949a382f-0bac-4cf9-9a0f-aeb33ea37328	0	2024-09-07 01:11:57.532217	f
839b756c-143e-4c60-8232-794a6a8d57aa	0	2024-09-07 01:11:57.532217	f
c4f2365f-1323-4c2f-8b3b-840f1f07f1dd	0	2024-09-07 01:11:57.532217	f
5f1adcaf-9836-48e9-b003-54981b1112cc	0	2024-09-07 01:11:57.532217	f
7d000ba8-ce5d-4441-aadd-bbe99d94b7b9	0	2024-09-07 01:11:57.532217	f
50ddf17a-490e-425c-b406-99456392e9e1	0	2024-09-07 01:11:57.532217	f
87ff6a06-1d0b-4006-9c22-a5808014c7ac	0	2024-09-07 01:11:57.532217	f
616e0893-388c-473f-b5cc-df803242e6fb	0	2024-09-07 01:11:57.532217	f
7e01c64c-ddbf-4aa9-98fa-38223bc37ead	0	2024-09-07 01:11:57.532217	f
59c130d1-f386-463e-ae7f-4e36771d3b51	0	2024-09-07 01:11:57.532217	f
8348c298-0ea7-4a4a-8b43-aa3d7da3de2d	0	2024-09-07 01:11:57.532217	f
4fe16b5e-86ad-4e22-846b-c1217900e20a	0	2024-09-07 01:11:57.532217	f
08c64cf9-a684-42c4-9452-5d895e90957c	0	2024-09-07 01:11:57.532217	f
e4ebb98c-c0a1-4923-9ba2-f9aba4ca6b98	0	2024-09-07 01:11:57.532217	f
f7baaa5a-50c8-4b71-aacd-2259243470cb	0	2024-09-07 01:11:57.532217	f
f37b5add-b32b-4c0f-8311-2bfa58f744a3	0	2024-09-07 01:11:57.532217	f
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, team_name, key) FROM stdin;
90e3c6f3-43bc-4464-9ef4-fe87257de68d	Team#1(Isha_Latey_GYP)	js8f3k9mn7dl
a76084e2-6c59-40bd-ac66-781740b11ee4	Team#2(Nisarg_Desai_UDICT)	7d8lsf2m90fk
f37b5add-b32b-4c0f-8311-2bfa58f744a3	Team#3(Pooja_Jadhav_SOET)	8djs9f3k7mla
7e01c64c-ddbf-4aa9-98fa-38223bc37ead	Team#4(Ananta_Sonawane_GYP)	7dfk29sm83la
50ddf17a-490e-425c-b406-99456392e9e1	Team#5(Pranav_Niware_JNEC)	8j2kf7s9mdla
4fe16b5e-86ad-4e22-846b-c1217900e20a	Team#6(Riddhi_Lakade_JNEC)	f8k2jd7sm9la
132f91ff-e426-4ef8-a18a-a88fb2ed0472	Team#7(Bhakti_Jadhav_GYP)	jf2lk8n30sd7
59c130d1-f386-463e-ae7f-4e36771d3b51	Team#8(Manasvi_Tambe_JNEC)	j9f2ks8mld7a
8348c298-0ea7-4a4a-8b43-aa3d7da3de2d	Team#9(Shaikh_Nadeem_SOET)	4ksm8f2dj7la
8d732863-fc7a-43e9-8102-adb90c3e0800	Team#11(Shaikh_Danish_UDICT)	js9f2ld7n8k3
f7baaa5a-50c8-4b71-aacd-2259243470cb	Team#10(Ved_Dhanokar_UDICT)	k9fj2d7slm8a
5f1adcaf-9836-48e9-b003-54981b1112cc	Team#12(Riddhi_Salunke_GYP)	k9fn7d8js6ma
27979cb0-1b73-4e65-9523-231e38c185a0	Team#13(Faiz_Shaikh_JNEC)	2kdj7s94lfm8
839b756c-143e-4c60-8232-794a6a8d57aa	Team#14(Archit_Mahajan_GYP)	js7k29f8ldm4
9439b071-cd92-4a85-b492-a7eaad8d48cd	Team#15(Aniruddha_Shebe_SOET)	93nskf72ndlf
08c64cf9-a684-42c4-9452-5d895e90957c	Team#16(Madiha_Ansari_JNEC)	js9f8k2m7lda
b0fc951e-cecf-4f8b-a971-a3041560cc2c	Team#17(Om_Deshmukh_JNEC)	hs8kd9f2j4sm
b27eb79a-97c4-4103-a399-66d528e63e62	Team#18(Rahul_Sharma_JNEC)	f2kd83s9lm7a
616e0893-388c-473f-b5cc-df803242e6fb	Team#19(Jay_Sawant_JNEC)	9fj2kd8sm7l3
15c050ca-4244-4318-b262-989b9fd6c591	Team#20(Vansh_Joshi_SOET)	4dkf8j2ms93a
c8403bd6-ebbb-41f7-b232-1542fdc50bfd	Team#21(Hemant_Parmar_JNEC)	p9fn8k3sld2a
0c040bf3-613b-453e-8395-d4e22cd37dd0	Team#22(Aashadip_Kachole_GYP)	m2jf7sl8a3dc
7d000ba8-ce5d-4441-aadd-bbe99d94b7b9	Team#23(Syed_Umair_JNEC)	m3k7djf9ls8a
43c2c4ba-38ef-4060-bde3-dfc8bed814d1	Team#24(Ayush_Kamble_SOET)	v8k7djs3l9fn
87ff6a06-1d0b-4006-9c22-a5808014c7ac	Team#25(Asjad_Pathan_UDICT)	4dkf7j2s9mla
3fcf0fa5-ea9c-4b9d-8d99-55175637b573	Team#26(Vaishnavi_Jambagi_JNEC)	fj3kd84hs92a
e4ebb98c-c0a1-4923-9ba2-f9aba4ca6b98	Team#27(Anushree_Kasture_JNEC)	f4kd7s8j9mla
4635beff-63ef-4370-83d1-4cc98c43c58d	Team#28(Rushiraj_Kharate_JNEC)	v7dkl93js82a
cbfdf7a9-a076-4f7d-a94a-8e2e5964e6d5	Team#29(Samarpan_Daniel_JNEC)	9fj2ksm5l8a3
949a382f-0bac-4cf9-9a0f-aeb33ea37328	Team#30(Bhumika_Patil_UDICT)	9dj3kf7s8m2a
c4f2365f-1323-4c2f-8b3b-840f1f07f1dd	Team#31(Bhumika_Munot_JNEC)	4djs8f3km92l
eadf82d8-61d1-4767-890f-4e76b33ae342	Team#32(Akram_Shaikh_UDICT)	k8fn7js39adl
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
-- Name: eliminated eliminated_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eliminated
    ADD CONSTRAINT eliminated_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


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
-- Name: questions r_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT r_fk FOREIGN KEY (round_num) REFERENCES public.rounds(round_num);


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

