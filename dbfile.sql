--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.2)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.2)

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
1f06c50b-6089-44f3-92b2-2105a71afe40	Which of the following is NOT a type of computer memory?	CPU	ROM	RAM	Cache	3	1
f9a969cf-da06-49e8-9789-e339b6c988cb	Given the decimal number 15, how can we represent this number in binary form?	1111	1100	1010	1001	1	1
5823fda6-6e39-4211-95b7-3fcb17d53b18	1) git add 2) git commit 3) git _______?	pull	push	pullout	clone	2	1
254af5a0-2cd0-42dd-baa1-4948123277c2	Which of the following is NOT a high-level programming language?	Python	Assembly	Java	C++	2	1
8972cd20-9a79-4e40-9cc1-68a54ec42f10	How do you delete everything in a directory in Linux?	rm -rf ./	rm -d ./	rm --all	rm --all ./	1	1
f43be1f1-d85e-48f4-b20f-0f87e859d523	What is the process of converting plaintext into ciphertext called?	Decryption	Encryption	Hashing	Encoding	2	1
b5bb9a03-6a27-4d21-8891-7bfaf0e17e42	Which technology is used for wireless communication over *very* short distances?	Bluetooth	Wifi	Cellular	Satellite	1	1
98c86946-4ea9-469e-9ff7-f7a2fa46065d	What will be the output of the following Python code: `print(15 // 4)`	3	3.75	4	3.5	1	1
6ef39bd6-750f-4ed9-ad1b-d5b2205b3566	Which of these is not a searching algorithm?	DFS	A-Star	Dijkstra	Kadane's Algorithm	4	1
9f7f46fa-2b71-47df-a9ee-c4c713d5bbf6	What is the core component of an Artificial Neural Network?	Synapse	Dendrite	Neuron	Axon	3	1
3b7ca292-fbc2-4ddf-b80c-caec3934ce90	What is the purpose of a hash function in a hash table?	To sort the data	To map keys to indices	To encrypt the data	To compress the data	2	1
7f597ca2-4425-4249-b7a7-2951c18b6b7c	In a binary search tree, which traversal method produces a sorted output?	Inorder	Preorder	Postorder	Any one of the above	1	1
64ccbc20-cc3c-47f0-b5f1-4d5bbfbb5549	Which of these is a cloud computing service model?	Infrastructure as a Service (IaaS)	Platform as a Service (PaaS)	Software as a Service (SaaS)	All of the above	4	1
829e93af-9deb-4cba-8729-782509eca15b	Which of the following is a divide-and-conquer algorithm?	Bubble Sort	Selection Sort	Merge Sort	Insertion Sort	3	1
6af31f35-39e9-4869-900a-f45193eea092	What does the following list comprehension in Python yield: `[i for i in range(10)]`	[-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]	[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]	[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]	3	1
20e9bd03-f245-4245-ac0d-f2c25e9e28d0	Which of the following is not a feature of Object-Oriented Programming (OOP)?	Encapsulation	Inheritance	Polymorphism	Recursion	4	1
11e6c85d-5f6d-4390-ae58-def31baf7abe	In SQL, which of the following commands is used to remove a table from a database?	DELETE	DROP	REMOVE	ERASE	2	1
2e5e0cd1-766c-444c-b89f-b90ef1fd392d	The minimum number of stacks needed to implement a queue is	3	1	2	4	3	1
ab836b8d-ed6f-4dbc-ace6-814c1572ae3a	In the context of version control, what does "Git" primarily manage?	Database transactions	File versions	Networking protocols	Web sessions	2	1
68bc3298-3018-4c27-80db-e77a7fcb6015	What language did WhatsApp use in their launching phase to scale to millions of users with a small team of engineers?	Erlang	C++	Java	Python	1	0
1720674b-0daa-4407-9bec-ee60b4f0ddad	What is the output of this list comprehension? `[char for char in "Python" if char.isupper()]`	["P", "y", "t", "h", "o", "n"], 	["P", "y", "t", "h"]	["P"]	["P", "n"]	3	0
b105a16b-0c4f-48d9-ab32-5835bd1127b2	Which of the following is a key characteristic of a relational database?	 Hierarchical data structure	Data is organized in tables (relations)	Network data model	 Data is stored as objects	2	0
9de2e6fe-361e-4ced-aa63-4e753ed339df	Which of the following statements is true about Java?	Java supports multiple inheritance using classes.	Java uses pointers for memory management.	Java is platform-independent due to the JVM.	Java allows operator overloading.	3	0
587b5ae1-9ae1-4e4a-89ca-8b4d7fe0cd59	In Java, which of the following is used to handle exceptions?	if-else	switch-case	try-catch	do while loop	3	0
a34f99e0-a20a-455c-8e22-36da392295c3	Which of the following is an advantage of a linked list over an array?	Random access of elements	Fixed size	Better cache locality	Dynamic size	4	0
6df1aa51-9cfd-4d74-832a-aa7c972e2d17	What is the purpose of exception handling in programming?	To manage and respond to runtime errors.	To optimize code performance.	To log function calls and results.	To predefine input values for functions.	4	0
2195d9c4-2a34-4050-a4c7-767738b5899a	 In Python, which of the following is not a valid data type?	List	Tuple	LinkedList	Integer	3	0
553ab931-a8a6-4296-988e-bb70e6a27f4f	VST stands for:	Virtualisation Software Technology	Visual SaaS Template	Virtual Studio Technology	Vacant Swapping Technique	3	0
23c8de49-3a25-43c0-b8c8-bc03a05099c2	 What is a "data structure" in programming?	A collection of functions for data transformation.	Organizing and storing data for efficient access and modification.	An algorithm for processing data.	Syntax for declaring variables and constants.	2	0
42e05a96-8f9c-4fcd-8457-c4a464ac80af	Which of the following is a valid declaration of a pointer in C?	int ptr;	int *ptr;	int &ptr;	pointer int ptr;	2	0
0d955716-b6d1-4e4e-b8c2-5be8cbcb0819	In Java, which method is used to start a thread?	run()	start()	init()	execute()	2	0
0720ac64-d29c-4936-834e-61d3f32d9a49	Which of the following code has the fastest execution time?	O(nlog n)	O(n)	O(n!)	O(log n)	4	0
66d9264a-a94f-4658-b228-bd36b4a33309	What is "recursion" in programming?	Optimizing function execution through loops.	Predefining input values for functions.	A function calling itself to solve smaller sub-problems.	Repeated execution of code until a condition is met.	3	0
a015ba7e-73d4-4ba8-82cc-8b9d9db98137	What does ACID stand for in the context of databases?	Atomicity, Consistency, Isolation, Durability	 Atomicity, Concurrency, Integrity, Durability	Aggregation, Consistency, Isolation, Durability	Abstraction, Consistency, Isolation, Data	1	0
9ed356b9-a3f1-4995-ae64-7f48a9e7ea30	How do you execute a python file?	`run <filename>.py` in the terminal.	`execute <filename>.py` in the shell.	`python <filename>.py` in the command line.	`python3 run <filename>.py` in the command line.	3	0
9c0aef1d-683e-477f-9700-a6ddc0b9cef2	What is the time complexity of binary search in a sorted array?	O(n)	O(log n)	O(n log n)	O(n²)	2	0
4995d4ae-0e9d-41ac-8c83-38a85fd548b8	What does BFS stand for?	Binary-First Search	Breadth-First Search	Binary-Finding System	Breadth-Finding Strategy	2	0
edf4ecb8-6605-4e98-807e-705ce6e57981	What does SQL stand for?	Standard Query Language	System Query Language	Structured Query Language	System Query Language	3	0
1f7b67cb-c707-4b7a-ae99-7b47a3ad94a5	In a relational database, which constraint ensures that a column cannot have NULL values?	FOREIGN KEY	UNIQUE	NOT NULL	DEFAULT	3	0
b902294f-f1c9-46c5-a255-09403ec1bd0e	How many pointers at max are necessarily changed for the insertion in a singly linked list?	1	3	0	2	4	2
ffd30f1b-7c36-4916-984f-e1dd1000857a	The type of pointer used to point to the address of the next element in a singly linked list?	Pointer to Char	Pointer to Int	Pointer to Node	Pointer to String	3	2
1b5787e5-d587-4e16-89e1-2e65300b03f2	Which of the following is not the application of stack?	Data Transfer between two asynchronous process	Compiler Syntax Analyzer	Tracking of local variables at run time	A parentheses balancing program	1	2
644fe588-9930-4a97-8928-e241bfd3b2df	What is the value of the postfix expression 8 11 7 4 + – *?	0	-33	33	-9	1	2
5cea61ee-b099-4eba-913d-4f15a95e9bab	What is the purpose of the SQL query shown in the snippet? `SELECT * FROM employees WHERE department = 'Sales';`	Insert new employee records	Update existing employee records	Retrieve employee records from the 'Sales' department	Delete employee records from the 'Sales' department	3	2
d101b02d-991a-404a-b75d-72ceb99ae0c4	What is a null pointer reference? (Hint: CrowdStrike suffered a lot because of this)	Pointer to a memory address that has been deallocated	A default variable called "null" to initialise a constructor in C++.	A pointer that has been declared but not initialised	A pointer that could be used to reference more than one locations at the same time.	1	2
58ae92d2-aa2b-4dd3-8051-f1c45eba7371	Which of these is a postfix expression?	a+c-d	ab+ cd- *	ab(cd+)- *	*ab-+cde	2	2
e8df756c-121c-4cee-822b-41ced4f2d7ee	Which of These is **NOT** an AWS service?	S3	ABS	RDS	EC2	2	2
83f39ae4-795e-45e2-971f-38bd5a064634	Which of These is **NOT** a Page Replacement Algorithm	FIFO	LRU	LIFO	Optimal Page Replacement	3	2
41393653-323f-4e9b-b830-1a06f9df281c	Which of the following is a non-preemptive scheduling algorithm?	Round Robin	Shortest Job First (SJF)	Priority Scheduling	First-Come, First-Served (FCFS)	4	2
da68948c-0f1b-4b17-b816-861ce353ce64	What is the output of the following Java code? `public class Main{      public static void main(String []args){         int x = 10;         int y = 5;         int z = (x > y) ? x : y;         System.out.println(z);      } }`	10	5	15	syntax error	1	2
184d6b0c-634e-475e-9434-64d8ee2bc6d2	Which of the following algorithms is specifically used for finding the shortest path in a graph?	Depth-First Search (DFS)	Breadth-First Search (BFS)	Dijkstra’s Algorithm	Heuristic Search	3	2
e6270dc0-94ae-4465-9f4f-b2c132fc1252	Which of the following sorting algorithms is not stable?	Merge Sort	Bubble Sort	Quick Sort	Insertion Sort	3	2
5c6c4305-ed1b-433d-9c99-045c9315b5d1	Which SQL keyword is used to remove duplicate records in a query result?	UNIQUE	DELETE	SELECT	DISTINCT	4	2
f5fa6173-e6ab-445f-8c5a-58334714881c	Which of the following algorithms is NOT used for encryption?	AES	RSA	SHA-256	Blowfish	3	2
0e89fc88-e7b5-48ba-8ab3-20ac6f0e6d14	What is the worst-case time complexity of quicksort?	O(n)	O(log n)	O(n log n)	O(n²)	4	2
7b8d0255-9209-4499-a91b-15a3ff75e1d8	What is Bob doing here in the 8th episode of the 2nd season of Stranger Things ![](https://martin-m.org/images/Stranger-Things-S1E8-Code-Closeup.png)	Developing a web application for storing passwords	Running away from Demogorgons and brute-forcing a 3-digit password	Running away from Demogorgons and brute-forcing a 4-digit password	Training a model for classifying Demogorgons	3	2
caefb812-2daf-4708-9267-d10ecf6d000c	(2^2^2^2^2^2^2^2^2^2^2^2^2^2^2^2) mod 10 is? (a^b is read as "a raised to the power of b")	3	8	6	2	3	4
e527492e-ad50-45ce-843d-18ca0a8d1141	There are 23 people, labelled from 1 to 23, in a circle. '1' has a knife (chaku) and kills the person next to him (2) and passes the knife to 3, 3 kills 4 and gives the knife to 5. This carries on until there is only one person alive (by god's grace).	1	15	8	23	4	4
3722f931-9438-45b4-9845-56cc056f879c	In object-oriented programming, what is the concept of polymorphism?	Polymorphism is the process by which a class (the child or subclass) acquires attributes and behaviors from another class (the parent or superclass), allowing for code reuse and the creation of hierarchical relationships between classes.	Polymorphism is the process by which a single class can inherit properties and behaviors from multiple parent classes, combining the functionality of all the parent classes into one.	Polymorphism is the technique of encapsulating data and methods within a class to protect the internal state of the object and prevent unauthorized access from outside code.	Polymorphism describes the ability of a function to change its behavior based on the number and type of parameters passed to it, enabling flexible function definitions.	4	2
b9fdfbcb-a7e4-474a-9bc4-a7efe886f201	What does the term "latency" refer to in networking?	The amount of data that can be transferred in a given time	The time taken for a data packet to travel from source to destination	The number of errors per unit of time	The frequency of data collisions	2	2
92cd725c-b05b-4c3b-8c2e-94858efae21b	Which of the following algorithms is typically used in the TCP protocol to prevent network congestion?	RSA	Dijkstra's Algorithm	Sliding Window Protocol	Slow Start	4	2
750caf23-ad65-4632-af03-c2a5ecfa5648	What is the output of the following C++ code? `#include <iostream> using namespace std;  int main() {     int a = 10;     int b = a++ + ++a;     cout << b;     return 0; }`	21	20	22	19	3	3
9270e626-a441-494e-b392-5460b0b84b3d	You are tasked with optimizing the performance of a web application. Which technique involves storing frequently accessed data in a store, reducing the need to fetch it from the original source and potentially improving response times?	Load Balancing	Compression	Minification	Caching	4	3
fe77033f-2fec-4829-8f98-34ca1c794476	In operating systems, what is the name of the memory management technique that divides memory into fixed-size blocks called pages?	Segmentation	Swapping	Paging	Thrashing	3	3
1fe1cf73-8912-4862-9037-e616815f3641	Consider a scenario where you need to design a fault-tolerant system that can continue operating even if some of its components fail. Which architectural pattern involves replicating critical components and distributing them across multiple nodes to ensure high availability and resilience?	Microservices Architecture	Monolithic Architecture	Distributed Architecture	Layered Architecture	3	3
eb105f20-f9ee-44f1-9692-0a750985d1e9	Which of the following is a type of cyber attack that involves tricking users into revealing sensitive information?	Malware	Ransomware	Phishing	Denial of Service (DoS)	3	3
6fd6856b-beae-4379-b008-3c8d160e3b77	What is the output of the following Python code snippet? `x = [1, 2, 3, 4] y = x.copy() y.append(5) print(x, y) `	`[1, 2, 3, 4] [1, 2, 3, 4, 5]`: The `copy()` method creates a shallow copy, so modifying `y` does not affect `x`	`[1, 2, 3, 4] [1, 2, 3, 4]`: Both lists are references to the same object, so changes to`y` are reflected in `x`.	`[1, 2, 3, 4, 5] [1, 2, 3, 4, 5]`: Both `x` and `y` are updated simultaneously because `copy()` is not used.	Error: The `copy()` method is not valid for lists.	1	3
1f723e16-dd93-4149-94b2-e75b799c2a80	Which of these is **NOT** a method to exit the Vim text editor?	:q!	ZZ	ZQ	:w	4	3
21665f84-ab8b-4548-b133-aced02f81c28	What is the purpose of load balancing in system design?	To encrypt data	To compress data for faster transmission	To cache frequently accessed data	To distribute traffic across multiple servers	4	3
70b95916-6d2e-4f90-95fc-73827cd332c2	What programming concept is demonstrated in the provided code snippet? `def calculate_factorial(n):     if n == 0:         return 1     else:         return n * calculate_factorial(n - 1)`	Iterative	 Recursion	Polymorphism	Encapsulation	2	3
8625edda-297b-4deb-867b-a3166f90c3d5	Which of these HTTP methods should not be used while sending a request body?	PUT	GET	POST	PATCH	2	3
72fa0746-cae1-4f18-a13b-d3a2a081f803	Which of these is not a defining feature of Redis?	Multithreading	In-memory caching	Pub/sub	Support for linear data structures	1	3
3c6455c7-c0c1-476e-a5d6-9a6120b7858e	What is the output of the following code snippet:  `int x = 5;  int y = x++ + ++x;  std::cout << y;` ? 	10	12	11	13	2	3
29949d6d-be7c-42e9-96e5-71aa24c446f6	What would be the optimal time complexity for generating Fibonacci series?	O(logn)	O(n)	O(2^n)	O(n^2)	1	3
a3767171-b3ce-40fa-858f-b2fd0249dabc	Which of the following HTTP status codes indicates that the request was successful and the server returned the requested data?	200	301	404	500	1	3
fa24e896-af6b-4fc7-8903-a6f6ef93f5f8	What will be the output of the following C++ code? `#include <iostream> using namespace std;  int main() {     int a = 5, b = 10, c = 15;     int x = (a > b) ? (b > c) ? b : c : (a > c) ? a : c;     cout << x;     return 0; }`	5	10	15	Compilation error	3	3
851cac5c-ca59-48b9-a535-233348ca94e7	What programming concept is demonstrated in the following Python code snippet? `class Animal:     def make_sound(self):         print("Animal sound")  class Mammal(Animal):     def has_fur(self):         print("Has fur")  class Dog(Mammal):     def bark(self):         print("Woof!")` 	Multilevel Inheritance	Multiple Inheritance	Hierarchical Inheritance	Single Inheritance	1	3
f09f57f1-4d2a-433a-836b-d90ed6902b52	In a relational database, what is the purpose of a primary key?	A primary key is used to define the data type of a table and ensure that each record in the table is stored in sequential order based on the primary key values.	A primary key uniquely identifies each record in a table, ensuring that no two rows have the same primary key value, and it cannot contain NULL values.	A primary key is a special key that is used to group records together in a table, often used for sorting and filtering data efficiently.	A primary key is an optional field in a table that can be used to create a relationship between two or more tables in the database.	2	3
d58dfd2f-d406-4d99-88c1-d44a16698753	What is a candidate key in relational databases?	It is any group of keys that can be a candidate for uniquely identifying the tuple	It has information about candidates in a table	It is the minimal group of keys that can be a candidate for uniquely identifying the tuple	It is all the attributes in the table barring the primary key	3	3
7d19f3ae-83e6-41c9-81bc-32c5e92be597	Which of the following protocols is used for secure communication over an untrusted network like the Internet?	HTTP	FTP	SSH	Telnet	3	3
45d9087e-7deb-44b8-a477-af09db8f9548	In Python, what will be the output of the following code snippet? `def func(x, y=[]):     y.append(x)     return y  print(func(1)) print(func(2))`	[1] [2]	[1] [1, 2]	[1, 2] [1, 2]	[1, 2] [2]	2	3
35c4cbbe-ca16-45e6-b638-57e0eeff0ec9	.-- .... .- - / .. ... / .---- .-.-. .----	.----	...--	..---	....-	3	4
af527c8f-48d4-49fa-8d90-97fc9cc86ec0	A Caesar Cipher is an encryption technique that was famously used by, you guessed it right, Julius Caesar! In this technique, you shift the input characters 3 places forward. "A" becomes "D" ("A"->"B"->"C"->"D"), "G" becomes "J" ("G"->"H"->"I"->"J") and "Z" becomes "C" ("Z"->"A"->"B"->"C") due to rotation. Thus, "TECH HUNT" would become "WHFK KXQW". Find the Caesar Cipher for the GFG motto. Make sure only Julius Caesar can decode the glorious motto of GFG!	OHDEQ, SUDFGLFH, NQG HKFRO	OHDUQ, SUDFWLFH, DQG HAFHO	YRNEA, CENPGVPR, NAQ RKPRY	YHNUA, SEDPWVFR, DAG RAPHY	2	4
8255b41d-28ab-4ae0-8896-7c8bd94ea66f	Given the numbers [999, 1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018, 1019, 1020], find the maximum number of times you will have to remove sets of any 3 numbers such that their greatest common divisor is 1 until there are no such sets remaining.	3	4	5	6	3	4
b7efdfc7-7664-4d22-ba85-d66e0c0d8ad7	You are given a list of integers where every element appears twice except for one. You need to find that single element in the most efficient way. Which of the following algorithms would you choose?	Sort the array and compare adjacent elements.	Use a hash map to count the frequency of each element.	Use the XOR bitwise operation on all elements.	Iterate through the list comparing each element with every other element. give answer	3	4
6c922d85-d1a1-4495-9376-ec17f67e3e84	Which data structure is best suited for implementing a priority queue?	Array	Linked List	Stack	Heap	4	1
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
90e3c6f3-43bc-4464-9ef4-fe87257de68d	Team#1	js8f3k9mn7dl
a76084e2-6c59-40bd-ac66-781740b11ee4	Team#2	7d8lsf2m90fk
f37b5add-b32b-4c0f-8311-2bfa58f744a3	Team#3	8djs9f3k7mla
7e01c64c-ddbf-4aa9-98fa-38223bc37ead	Team#4	7dfk29sm83la
50ddf17a-490e-425c-b406-99456392e9e1	Team#5	8j2kf7s9mdla
4fe16b5e-86ad-4e22-846b-c1217900e20a	Team#6	f8k2jd7sm9la
132f91ff-e426-4ef8-a18a-a88fb2ed0472	Team#7	jf2lk8n30sd7
59c130d1-f386-463e-ae7f-4e36771d3b51	Team#8	j9f2ks8mld7a
8348c298-0ea7-4a4a-8b43-aa3d7da3de2d	Team#9	4ksm8f2dj7la
8d732863-fc7a-43e9-8102-adb90c3e0800	Team#11	js9f2ld7n8k3
5f1adcaf-9836-48e9-b003-54981b1112cc	Team#12	k9fn7d8js6ma
27979cb0-1b73-4e65-9523-231e38c185a0	Team#13	2kdj7s94lfm8
839b756c-143e-4c60-8232-794a6a8d57aa	Team#14	js7k29f8ldm4
9439b071-cd92-4a85-b492-a7eaad8d48cd	Team#15	93nskf72ndlf
08c64cf9-a684-42c4-9452-5d895e90957c	Team#16	js9f8k2m7lda
b0fc951e-cecf-4f8b-a971-a3041560cc2c	Team#17	hs8kd9f2j4sm
b27eb79a-97c4-4103-a399-66d528e63e62	Team#18	f2kd83s9lm7a
616e0893-388c-473f-b5cc-df803242e6fb	Team#19	9fj2kd8sm7l3
15c050ca-4244-4318-b262-989b9fd6c591	Team#20	4dkf8j2ms93a
c8403bd6-ebbb-41f7-b232-1542fdc50bfd	Team#21	p9fn8k3sld2a
0c040bf3-613b-453e-8395-d4e22cd37dd0	Team#22	m2jf7sl8a3dc
7d000ba8-ce5d-4441-aadd-bbe99d94b7b9	Team#23	m3k7djf9ls8a
43c2c4ba-38ef-4060-bde3-dfc8bed814d1	Team#24	v8k7djs3l9fn
87ff6a06-1d0b-4006-9c22-a5808014c7ac	Team#25	4dkf7j2s9mla
3fcf0fa5-ea9c-4b9d-8d99-55175637b573	Team#26	fj3kd84hs92a
e4ebb98c-c0a1-4923-9ba2-f9aba4ca6b98	Team#27	f4kd7s8j9mla
4635beff-63ef-4370-83d1-4cc98c43c58d	Team#28	v7dkl93js82a
cbfdf7a9-a076-4f7d-a94a-8e2e5964e6d5	Team#29	9fj2ksm5l8a3
949a382f-0bac-4cf9-9a0f-aeb33ea37328	Team#30	9dj3kf7s8m2a
c4f2365f-1323-4c2f-8b3b-840f1f07f1dd	Team#31	4djs8f3km92l
eadf82d8-61d1-4767-890f-4e76b33ae342	Team#32	k8fn7js39adl
f7baaa5a-50c8-4b71-aacd-2259243470cb	Team#10	k9fj2d7slm8a
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

