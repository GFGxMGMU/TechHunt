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
-- Data for Name: hints; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hints (loc_id, hint) FROM stdin;
1	I believe in you!👍
2	I believe in you!👍
3	I believe in you!👍
4	I believe in you!👍
5	I believe in you!👍
6	I believe in you!👍
7	I believe in you!👍
8	I believe in you!👍
10	I believe in you!👍
11	I believe in you!👍
12	I believe in you!👍
13	I believe in you!👍
14	I believe in you!👍
15	I believe in you!👍
16	I believe in you!👍
17	I believe in you!👍
18	I believe in you!👍
19	I believe in you!👍
20	I believe in you!👍
21	I believe in you!👍
22	I believe in you!👍
23	I believe in you!👍
9	I believe in you!👍
\.


--
-- Data for Name: location_count; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_count (loc_id, passed_count) FROM stdin;
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
4785bdbf-82e0-4782-b23d-1270c8fce3d9	Which of the following is NOT a type of computer memory?	RAM	ROM	CPU	Cache	3	2
90207c34-fb28-4d8f-8794-46b21d0ba2d6	Given the decimal number 15, how can we represent this number in binary form?	1111	1100	1010	1001	1	2
b247b838-dd99-45bb-b1d4-b58c4ed2c8f9	1) git add 2) git commit 3) git _______?	pull	push	pullout	clone	2	2
c5697e86-f3a8-4aea-8dd4-c0d50baf5411	Which of the following is NOT a high-level programming language?	Python	Assembly	Java	C++	2	2
238ac9aa-f3d9-44dd-8118-18c03ec068f8	How do you delete everything in a directory in Linux?	rm -rf ./	rm -d ./	rm --all	rm --all ./	1	2
51ced271-6903-4bdc-8dfb-a8664097c790	What is the process of converting plaintext into ciphertext called?	Decryption	Encryption	Hashing	Encoding	2	2
4e98564b-cf78-4b81-89fe-138a112926bc	Which technology is used for wireless communication over *very* short distances?	Bluetooth	Wifi	Cellular	Satellite	1	2
321d5922-d4ed-489a-a296-c5f50a5a73c1	What will be the output of the following Python code: `print(15 // 4)`	3	3.75	4	3.5	1	2
a137c2b6-3e1e-4ae8-9a49-2ee174bbbfa7	Which of these is not a searching algorithm?	DFS	A-Star	Dijkstra	Kadane's Algorithm	4	2
dde328b1-4fee-4efa-9055-834e58063327	What is the core component of an Artificial Neural Network?	Synapse	Dendrite	Axon	Neuron	4	2
d6e87e7e-dd51-4f09-bfab-6d8a4c128821	Which data structure is best suited for implementing a priority queue?	Array	Linked List	Stack	Heap	4	2
d012bc06-f1d8-47c3-814f-71b7468bad3f	What is the purpose of a hash function in a hash table?	To sort the data	To map keys to indices	To encrypt the data	To compress the data	2	2
63535c7e-f745-4a00-ba7b-092845d03faf	In a binary search tree, which traversal method produces a sorted output?	Inorder	Preorder	Postorder	Any one of the above	1	2
b996cc5c-4d3f-417d-ae68-1869bfb4dbd1	Which of these is a cloud computing service model?	Infrastructure as a Service (IaaS)	Platform as a Service (PaaS)	Software as a Service (SaaS)	All of the above	4	2
07432f4e-7de1-4e1b-872d-4fef8ee9d55e	Which of the following is a divide-and-conquer algorithm?	Bubble Sort	Selection Sort	Merge Sort	Insertion Sort	3	2
e4c1adef-bc5c-40c3-9a48-44bd7c08b05c	What does the following list comprehension in Python yield: `[i for i in range(10)]`	[-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]	[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]	[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]	3	2
76cd0b5e-303d-4eac-90e4-890a85fd1ffc	Which of the following is not a feature of Object-Oriented Programming (OOP)?	Encapsulation	Inheritance	Polymorphism	Recursion	4	2
82039367-b163-4d3a-b1ba-a27ff8c50ac9	In SQL, which of the following commands is used to remove a table from a database?	DELETE	DROP	REMOVE	ERASE	2	2
6dfc6267-574d-48f7-ba37-c9071a05209d	The minimum number of stacks needed to implement a queue is	3	1	2	4	3	2
322d3805-5d2f-4ae4-a7fe-94e4df1cc543	In the context of version control, what does "Git" primarily manage?	Database transactions	File versions	Networking protocols	Web sessions	2	2
8e71b6b0-fa94-486a-9ccf-eff9d8419d0a	What language did WhatsApp use in their launching phase to scale to millions of users with a small team of engineers?	C++	Python	Java	Elixir	4	1
a2a32975-fc32-4e37-afe3-446fd0bc348d	What is the output of this list comprehension?\\n`[char for char in "Python" if char.isupper()]`	["P", "y", "t", "h", "o", "n"]	["P", "y", "t", "h"]	["P", "n"]	["P"]	4	1
1c1a1b0c-9016-4384-90be-7bf5b308d2b7	Which of the following is a key characteristic of a relational database?	 Hierarchical data structure	Data is organized in tables (relations)	Network data model	 Data is stored as objects	2	1
96cf63f9-6579-46b8-8375-32deff0b18d9	Which of the following statements is true about Java?	Java supports multiple inheritance using classes.	Java uses pointers for memory management.	Java is platform-independent due to the JVM.	Java allows operator overloading.	3	1
f194e877-0d7d-475b-bf25-68271e58cb87	In Java, which of the following is used to handle exceptions?	if-else	switch-case	try-catch	do while loop	3	1
770ff296-d343-4082-af43-376387005cac	Which of the following is an advantage of a linked list over an array?	Random access of elements	Fixed size	Better cache locality	Dynamic size	4	1
12007949-01bb-402d-8015-05e0570308db	What is the purpose of exception handling in programming?	To predefine input values for functions.	To optimize code performance.	To log function calls and results.	To manage and respond to runtime errors.	4	1
dfe07b28-8a6a-4f3e-8f5c-25ff4bc78c4a	 In Python, which of the following is not a valid data type?	List	Tuple	LinkedList	Integer	3	1
335de183-50d1-41fe-b211-8ef0d2c3cb4f	VST stands for:	Virtualisation Software Technology	Visual SaaS Template	Virtual Studio Technology	Vacant Swapping Technique	3	1
604b27ff-f84a-4eec-a24b-c7f983d4fa49	 What is a "data structure" in programming?	A collection of functions for data transformation.	Organizing and storing data for efficient access and modification.	An algorithm for processing data.	Syntax for declaring variables and constants.	2	1
7b901b07-6373-4ac4-a6df-8d828fd8ed5e	Which of the following is a valid declaration of a pointer in C?	int ptr;	int *ptr;	int &ptr;	pointer int ptr;	2	1
c1dbfd62-af56-4c73-a3e0-b6351675e376	In Java, which method is used to start a thread?	run()	start()	init()	execute()	2	1
03886b1f-4aa5-411d-a8aa-376affbe70e6	How is best-case time complexity represented?	Ω(1) (constant time)	Θ(n) (linear time)	O(n) (linear time)	Ω(n2) (quadratic time)	1	1
fd12010f-ece8-4dfb-98ac-5c6a6deef6b1	What is "recursion" in programming?	Optimizing function execution through loops.	Predefining input values for functions.	A function calling itself to solve smaller sub-problems.	Repeated execution of code until a condition is met.	3	1
28953493-0649-441b-bc8f-3da52497fa00	What does ACID stand for in the context of databases?	Atomicity, Consistency, Isolation, Durability	 Atomicity, Concurrency, Integrity, Durability	Aggregation, Consistency, Isolation, Durability	Abstraction, Consistency, Isolation, Data	1	1
27405548-8779-4290-9f28-07cf6aa6f4bd	How do you execute a python file?	`run <filename>.py` in the terminal.	`execute <filename>.py` in the shell.	`python <filename>.py` in the command line.	`python3 run <filename>.py` in the console.	3	1
a1358d41-5158-4c90-b313-f695485fde50	What is the time complexity of binary search in a sorted array?	O(n)	O(log n)	O(n log n)	O(n²)	2	1
1de37fdb-39bf-4d8b-a47e-eba0da9ba510	What does BFS stand for?	Binary-First Search	Breadth-First Search	Binary-Finding System	Breadth-Finding Strategy	2	1
73f6e243-ea53-4623-97bd-d6bfead56e5e	What does SQL stand for?	Standard Query Language	System Query Language	Structured Query Language	System Query Language	3	1
ec382593-335a-44df-bac9-c086b40a31e9	In a relational database, which constraint ensures that a column cannot have NULL values?	FOREIGN KEY	UNIQUE	NOT NULL	PRIMARY KEY	3	1
e5ffaa08-2b3a-47a1-adcf-597a4c8297b5	How many pointers at max are necessarily changed for the insertion in a linked list?	1	3	0	2	4	3
53d2625c-d0a5-4ffe-a847-db8c5881162e	The type of pointer used to point to the address of the next element in a linked list?	Pointer to Char	Pointer to Int	Pointer to Node	Pointer to String	3	3
615fbf55-3215-4b25-92f4-65a00ea75bbf	Which of the following is not the application of stack?	Data Transfer between two asynchronous process	Compiler Syntax Analyzer	Tracking of local variables at run time	A parentheses balancing program	1	3
bed824d3-5cac-41b8-8fec-871246ccb88a	What is the value of the postfix expression 8 11 7 4 + – *?	0	-33	33	-9	1	3
88c75752-5669-4ba0-a8ca-87634849c423	What is the purpose of the SQL query shown in the snippet?\\n`SELECT * FROM employees WHERE department = 'Sales';`	Insert new employee records	Update existing employee records	Retrieve employee records from the 'Sales' department	Delete employee records from the 'Sales' department	3	3
490e9cfd-a20c-4a40-9f70-135520f322fb	What is a null pointer reference? (Hint: CrowdStrike suffered a lot because of this)	Pointer to a memory address that has been deallocated	A default variable called "null" to initialise a constructor in C++.	A pointer that has been declared but not initialised	A pointer that could be used to reference more than one locations at the same time.	1	3
8ba8f9ad-26a2-4bc4-9798-7240a22d03ee	Which of these is a postfix expression?	a+c-d	ab+ cd- *	ab(cd+)- *	*ab-+cde	2	3
292e38e0-c08c-4ab1-84d2-00559cc103ac	Which of These is **NOT** an AWS service?	S3	ABS	RDS	EC2	2	3
dc9fca25-beb9-41c8-b768-bba9930b98a2	Which of These is **NOT** a Page Replacement Algorithm	FIFO	LRU	LIFO	Optimal Page Replacement	3	3
7cb71511-6a3c-42de-b0a0-06041d70508c	Which of the following is a non-preemptive scheduling algorithm?	Round Robin	Shortest Job First (SJF)	Priority Scheduling	First-Come, First-Served (FCFS)	4	3
576e2948-289c-4d3d-a3d5-a3115761f859	What is the output of the following Java code?\\n`public class Main{\\n     public static void main(String []args){\\n        int x = 10;\\n        int y = 5;\\n        int z = (x > y) ? x : y;\\n        System.out.println(z);\\n     }\\n}`	10	5	15	syntax error	1	3
1cb3baf2-9c4f-4f37-8c36-a283174c4dac	Which of the following algorithms is used for finding the shortest path in a graph?	Depth-First Search (DFS)	Breadth-First Search (BFS)	Dijkstra’s Algorithm	Floyd-Warshall Algorithm	3	3
5fa183ab-a146-4646-8776-74e9b15be188	Which of the following sorting algorithms is not stable?	Merge Sort	Bubble Sort	Quick Sort	Insertion Sort	3	3
36ced374-6bc6-4c59-81b5-2b07516968bc	Which SQL keyword is used to remove duplicate records in a query result?	UNIQUE	DELETE	SELECT	DISTINCT	4	3
0312cc42-57d0-45ef-b41e-cad2879937dd	Which of the following algorithms is NOT used for encryption?	AES	RSA	SHA-256	Blowfish	3	3
2b562b3f-dcca-4e41-8fdb-c977eab006e5	What is the worst-case time complexity of quicksort?	O(n)	O(log n)	O(n log n)	O(n²)	4	3
af6c8369-aced-4ba2-9824-02e525ace3ef	What is Bob doing here in the 8th episode of the 2nd season of Stranger Things ![](https://martin-m.org/images/Stranger-Things-S1E8-Code-Closeup.png)	Developing a web application for storing passwords	Running away from Demogorgons and brute-forcing a 3-digit password	Running away from Demogorgons and brute-forcing a 4-digit password	Training a model for classifying Demogorgons	3	3
8e060be9-ea93-4c2e-8a8b-168842ccea02	In object-oriented programming, what is the concept of polymorphism?	Polymorphism is the process by which a class (the child or subclass) acquires attributes and behaviors from another class (the parent or superclass), allowing for code reuse and the creation of hierarchical relationships between classes.	Polymorphism is the process by which a single class can inherit properties and behaviors from multiple parent classes, combining the functionality of all the parent classes into one.	Polymorphism is the technique of encapsulating data and methods within a class to protect the internal state of the object and prevent unauthorized access from outside code.	Polymorphism describes the ability of a function to change its behavior based on the number and type of parameters passed to it, enabling flexible function definitions.	4	3
cb3bff1f-8068-490b-8070-283a4a0a3d0f	What does the term "latency" refer to in networking?	The amount of data that can be transferred in a given time	The time taken for a data packet to travel from source to destination	The number of errors per unit of time	The frequency of data collisions	2	3
0d5afedd-9adb-4978-914c-464fec1f3437	Which of the following algorithms is typically used in the TCP protocol to prevent network congestion?	RSA	Dijkstra's Algorithm	Sliding Window Protocol	Slow Start	4	3
29e77f92-646a-47a8-8b2c-89b4dd75855b	What is the output of the following C++ code?\\n`#include <iostream>\\nusing namespace std;\\n\\nint main() {\\n    int a = 10;\\n    int b = a++ + ++a;\\n    cout << b;\\n    return 0;\\n}`	21	20	22	19	3	4
61ebb2d2-34b2-4c4e-8a67-6e03a731c388	You are tasked with optimizing the performance of a web application. Which technique involves storing frequently accessed data in a store, reducing the need to fetch it from the original source and potentially improving response times?	Load Balancing	Compression	Minification	Caching	4	4
e66608f2-78f6-4204-9ff9-61e5da9e1312	In operating systems, what is the name of the memory management technique that divides memory into fixed-size blocks called pages?	Segmentation	Swapping	Paging	Thrashing	3	4
4deceacd-b960-4f3c-808b-d07c1bee53e2	Consider a scenario where you need to design a fault-tolerant system that can continue operating even if some of its components fail. Which architectural pattern involves replicating critical components and distributing them across multiple nodes to ensure high availability and resilience?	Microservices Architecture	Monolithic Architecture	Distributed Architecture	Layered Architecture	3	4
3fd84d8a-1871-48aa-9b11-b7ac705440ec	Which of the following is a type of cyber attack that involves tricking users into revealing sensitive information?	Malware	Ransomware	Phishing	Denial of Service (DoS)	3	4
cd23d171-6f27-44cd-a629-c87e879a5aca	What is the output of the following Python code snippet?\\n`x = [1, 2, 3, 4]\\ny = x.copy()\\ny.append(5)\\nprint(x, y)\\n`	`[1, 2, 3, 4] [1, 2, 3, 4, 5]`: The `copy()` method creates a shallow copy, so modifying `y` does not affect `x`	`[1, 2, 3, 4] [1, 2, 3, 4]`: Both lists are references to the same object, so changes to`y` are reflected in `x`.	`[1, 2, 3, 4, 5] [1, 2, 3, 4, 5]`: Both `x` and `y` are updated simultaneously because `copy()` is not used.	Error: The `copy()` method is not valid for lists.	1	4
426e6f91-dbf0-4ff3-93d7-4805805931d1	Which of these is **NOT** a method to exit the Vim text editor?	:q!	ZZ	ZQ	:w	4	4
aefadeec-8cda-4fa5-ac2e-4dba676847f1	What is the purpose of load balancing in system design?	To encrypt data	To compress data for faster transmission	To cache frequently accessed data	To distribute traffic across multiple servers	4	4
2b7a101e-08e2-4e81-9b61-5bfda02dac49	What programming concept is demonstrated in the provided code snippet?\\n`def calculate_factorial(n):\\n    if n == 0:\\n        return 1\\n    else:\\n        return n * calculate_factorial(n - 1)`	Iterative	 Recursion	Polymorphism	Encapsulation	2	4
ef51414e-f367-42ff-bd98-389590541edd	Which of these HTTP methods should not be used while sending a request body?	PUT	GET	POST	PATCH	2	4
6786c66d-cdd0-495a-8726-c5d4ae2dc432	Which of these is not a defining feature of Redis?	Multithreading	In-memory caching	Pub/sub	Support for linear data structures	1	4
899281b6-bc5d-4bbc-af85-a6501cf5e8ad	What is the output of the following code snippet: \\n`int x = 5; \\nint y = x++ + ++x; \\nstd::cout << y;` ? 	10	12	11	13	2	4
03439243-c410-46f8-84b1-d1d53d0c5c9b	What would be the optimal time complexity for generating Fibonacci series?	O(logn)	O(n)	O(2^n)	O(n^2)	1	4
40278bf6-d1fd-4e65-bf9a-21344bcd8ce4	Which of the following HTTP status codes indicates that the request was successful and the server returned the requested data?	200	301	404	500	1	4
af384321-e5bb-4e82-b3b2-2b941842a63c	What will be the output of the following C++ code?\\n`#include <iostream>\\nusing namespace std;\\n\\nint main() {\\n    int a = 5, b = 10, c = 15;\\n    int x = (a > b) ? (b > c) ? b : c : (a > c) ? a : c;\\n    cout << x;\\n    return 0;\\n}`	5	10	15	Compilation error	3	4
0c3634d1-8f0d-45ea-bc44-1f5770a3e386	What programming concept is demonstrated in the following Python code snippet?\\n`class Animal:\\n    def make_sound(self):\\n        print("Animal sound")\\n\\nclass Mammal(Animal):\\n    def has_fur(self):\\n        print("Has fur")\\n\\nclass Dog(Mammal):\\n    def bark(self):\\n        print("Woof!")`\\n	Multilevel Inheritance	Multiple Inheritance	Hierarchical Inheritance	Single Inheritance	1	4
a2537fee-8cb4-445f-b4a9-7dc770809eea	In a relational database, what is the purpose of a primary key?	A primary key is used to define the data type of a table and ensure that each record in the table is stored in sequential order based on the primary key values.	A primary key uniquely identifies each record in a table, ensuring that no two rows have the same primary key value, and it cannot contain NULL values.	A primary key is a special key that is used to group records together in a table, often used for sorting and filtering data efficiently.	A primary key is an optional field in a table that can be used to create a relationship between two or more tables in the database.	2	4
2e3beb28-dce6-4749-9513-ea1273783bce	What is a candidate key in relational databases?	It is any group of keys that can be a candidate for uniquely identifying the tuple	It has information about candidates in a table	It is the minimal group of keys that can be a candidate for uniquely identifying the tuple	It is all the attributes in the table barring the primary key	3	4
dc519872-bc05-4f74-9f64-5ca3538eedaf	Which of the following protocols is used for secure communication over an untrusted network like the Internet?	HTTP	FTP	SSH	Telnet	3	4
b477cdcd-6e2b-49b9-b1f8-1982fcfd3550	In Python, what will be the output of the following code snippet?\\n`def func(x, y=[]):\\n    y.append(x)\\n    return y\\n\\nprint(func(1))\\nprint(func(2))`	[1] [2]	[1] [1, 2]	[1, 2] [1, 2]	[1, 2] [2]	2	4
f76c9678-2584-4522-bb74-e02d5d0a9834	Given the numbers [999, 1000, 1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018, 1019, 1020], find the maximum number of times you will have to remove sets of 3 numbers such that their greatest common divisor is 1 until there are no such sets remaining.	3	4	5	6	3	5
3e97e968-6f00-4299-8984-549b242dc12c	Which caching strategy involves storing the most recently used items in the cache?	FIFO (First-In, First-Out)	LFU (Least Frequently Used)	Random Replacement	LRU (Least Recently Used)	4	5
fa36e902-f9a2-40ae-94a0-3b5488f5a585	Which of the following is NOT a layer in the TCP/IP model?	Application layer	Transport layer	Presentation layer	Network layer	3	5
dd4f6c1f-fe29-4da4-9b87-146717fbfde4	What is the primary benefit of using a message queue in system design?	To ensure data consistency	To improve database performance	To decouple components and enable asynchronous communication	To enable real-time communication	3	5
7c8e4c66-0355-4c17-8ded-78342d3381f7	Which of the following is NOT a common architectural pattern used in system design?	Microservices	Monolithic	Layered	Waterfall	4	5
f6af085a-640e-45dc-b6d2-57f7a636490f	A Caesar Cipher is an encryption technique that was famously used by, you guessed it right, Julius Caesar! In this technique, you shift the input characters 3 places forward. "A" becomes "D" ("A"->"B"->"C"->"D"), "G" becomes "J" ("G"->"H"->"I"->"J") and "Z" becomes "C" ("Z"->"A"->"B"->"C") due to rotation. Thus, "TECH" would become "WHFK KXQW". Find the Caesar Cipher for the GFG motto. Make sure only Julius Caesar can decode the glorious motto of GFG!	OHDEQ, SUDFGLFH, NQG HKFRO	OHDUQ, SUDFWLFH, DQG HAFHO	YRNEA, CENPGVPR, NAQ RKPRY	YHNUA, SEDPWVFR, DAG RAPHY	2	5
a6429608-acbe-461b-8a16-22ba35075c3d	Which of the following memory consistency models allows for out-of-order execution but ensures that all processes agree on the order of writes?	Sequential consistency	Causal consistency	Eventual consistency	Linearizability	1	5
a1785e47-c61a-4a61-b71a-90c0bf424eca	The five items: A, B, C, D, and E are pushed in a stack, one after other starting from A. The stack is popped four items and each element is inserted in a queue. The two elements are dequeue from the queue and pushed back on the stack. Now one item is popped from the stack. The popped item is	B	C	A	D	4	5
f9e186a5-2e57-456d-b45c-9190ecc8fc97	On a chess board with only one pawn, in how many ways can the hypothetical pawn that can move to all the three squares in front of it and also two squares forward at a time go from E2 to E7?	51	82	101	142	2	5
e3f8d5c2-fa2a-42b2-a1a0-04ea9e83da6c	Which company is widely recognized as a pioneer in the large-scale adoption and popularization of microservices architecture, and in what year did they begin this transition?	Amazon, 2006	eBay, 2011	Netflix, 2009	Google, 2008	3	5
3ba593d5-3ade-4c84-916e-66edb51b0063	Given two numbers `L` and `R`, your friend Chhakuli wants the maximum amount of numbers in ascending order she can fit into the given range (L and R inclusive) such that each number is bigger than the previous one and the difference of any two numbers is also greater than the difference of the previous two numbers. In short, the numbers keep on increasing and so does the difference between them, For example, the correct answer for `L=1` and `R=5` would be 3 (one of the set could be the numbers {1, 2, 5}). Chhakuli gives you `L=124` and `R=291`.	34	23	17	28	3	5
80c28598-3f95-4cb6-ac79-bf198f33a72e	We all love Ganeshotsav! Gotya is organising a *limbu-chamcha* competitions. It so happened that Gotya got a generous funding from the CSE department of JNEC and thus was able to award a prize money of 5K to anyone who finished the race, irrespective of their finishing place. Bad move! Gotya got more registrations than the number of hair strands on his head. Gotya was really smart though. He devised a 2D race where he could accomodate many more players.\\n\\nIn Gotya's race, there is a 6X6 grid with sides A, B, C and D, in anticlockwise order. 6 contestants start from the side A and 6 from the side B (from behind the squares, not on them yet). The ones who start at A must reach C to complete the race and the ones who start at B, should reach D. Gotya records their speeds (in squares per second; if the speed is 2, then the contestant moves 2 squares every second and reaches the finish line after 4 seconds; if the speed is 1, 7 seconds are required to reach the finish line) and they are in anticlockwise order: {2, 1, 2, 3, 1, 2} for contestants at A and {1, 1, 3, 2, 2, 1} for B. If two contestants each from A and B are at the same square at the same time, they collide and are **immediately** out of the race. Note: collisions only occur if two contestants are at the same square at unit time and **not in any other case**. Find the number of contestants who make it to the end. Here's a diagram to make it easy for you to understand:	5	6	7	8	2	5
ab3a6762-c6fd-4c05-b861-462d6ff54385	Black Widow and Hawkeye are on Vormir to get the Soul Stone. All of us know what happens next. This isn't that version of reality. Here, Dr Strange (in all his wisdom of infinity and probability) warns them that one of them is going to die. But, it can be prevented. They just have to play a little game on Vormir. If the ground 300 metres below is hit with a stone at a velocity `v` at the time of contact, it bounces the stone back up at a velocity `0.7v`. The stone can then bounce up any number of times on the ground, its velocity upon every subsequent bounce becoming 70% of its previous velocity. The stone will stop bouncing if the speed with which it hits the ground is less than 20 m/s. If the duo are able to make the stone bounce 7 times (the stone hitting the ground but not bouncing back up doesn't count) the normal stone will turn into the Soul Stone! They can even celebrate on the planet for some time with the local delicacy of Vormkarpale!\\nBut,  but,  but,  but,  butttttt, if they fail, both of them die!! So tread carefully.\\nYou have to determine the minimum velocity with which they have to throw the stone to get the Soul Stone back and heave a sigh of relief. Assume the gravity on Vormir is 5m/s<sup>2</sup> and there is negligible atmosphere	205m/s	101m/s	161m/s	229m/s	3	5
7d21f426-1a5f-48b6-9e59-c8869b66a007	Who is the GOAT?	Not Ayush	Maybe Ayush	Definitely Ayush	Bakri	4	5
eac491ef-b0ab-4556-b121-6e931ffb818d	Select A	A	B	C	D	1	5
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
\.


--
-- Data for Name: user_rounds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_rounds (user_id, round_num, entered_at, submitted) FROM stdin;
3fcf0fa5-ea9c-4b9d-8d99-55175637b573	1	2024-09-07 01:11:57.532217	f
0c040bf3-613b-453e-8395-d4e22cd37dd0	1	2024-09-07 01:11:57.532217	f
9439b071-cd92-4a85-b492-a7eaad8d48cd	1	2024-09-07 01:11:57.532217	f
c8403bd6-ebbb-41f7-b232-1542fdc50bfd	1	2024-09-07 01:11:57.532217	f
132f91ff-e426-4ef8-a18a-a88fb2ed0472	1	2024-09-07 01:11:57.532217	f
b0fc951e-cecf-4f8b-a971-a3041560cc2c	1	2024-09-07 01:11:57.532217	f
43c2c4ba-38ef-4060-bde3-dfc8bed814d1	1	2024-09-07 01:11:57.532217	f
a76084e2-6c59-40bd-ac66-781740b11ee4	1	2024-09-07 01:11:57.532217	f
90e3c6f3-43bc-4464-9ef4-fe87257de68d	1	2024-09-07 01:11:57.532217	f
15c050ca-4244-4318-b262-989b9fd6c591	1	2024-09-07 01:11:57.532217	f
4635beff-63ef-4370-83d1-4cc98c43c58d	1	2024-09-07 01:11:57.532217	f
cbfdf7a9-a076-4f7d-a94a-8e2e5964e6d5	1	2024-09-07 01:11:57.532217	f
27979cb0-1b73-4e65-9523-231e38c185a0	1	2024-09-07 01:11:57.532217	f
8d732863-fc7a-43e9-8102-adb90c3e0800	1	2024-09-07 01:11:57.532217	f
eadf82d8-61d1-4767-890f-4e76b33ae342	1	2024-09-07 01:11:57.532217	f
b27eb79a-97c4-4103-a399-66d528e63e62	1	2024-09-07 01:11:57.532217	f
949a382f-0bac-4cf9-9a0f-aeb33ea37328	1	2024-09-07 01:11:57.532217	f
839b756c-143e-4c60-8232-794a6a8d57aa	1	2024-09-07 01:11:57.532217	f
c4f2365f-1323-4c2f-8b3b-840f1f07f1dd	1	2024-09-07 01:11:57.532217	f
5f1adcaf-9836-48e9-b003-54981b1112cc	1	2024-09-07 01:11:57.532217	f
7d000ba8-ce5d-4441-aadd-bbe99d94b7b9	1	2024-09-07 01:11:57.532217	f
50ddf17a-490e-425c-b406-99456392e9e1	1	2024-09-07 01:11:57.532217	f
87ff6a06-1d0b-4006-9c22-a5808014c7ac	1	2024-09-07 01:11:57.532217	f
616e0893-388c-473f-b5cc-df803242e6fb	1	2024-09-07 01:11:57.532217	f
7e01c64c-ddbf-4aa9-98fa-38223bc37ead	1	2024-09-07 01:11:57.532217	f
59c130d1-f386-463e-ae7f-4e36771d3b51	1	2024-09-07 01:11:57.532217	f
8348c298-0ea7-4a4a-8b43-aa3d7da3de2d	1	2024-09-07 01:11:57.532217	f
4fe16b5e-86ad-4e22-846b-c1217900e20a	1	2024-09-07 01:11:57.532217	f
08c64cf9-a684-42c4-9452-5d895e90957c	1	2024-09-07 01:11:57.532217	f
e4ebb98c-c0a1-4923-9ba2-f9aba4ca6b98	1	2024-09-07 01:11:57.532217	f
f7baaa5a-50c8-4b71-aacd-2259243470cb	1	2024-09-07 01:11:57.532217	f
f37b5add-b32b-4c0f-8311-2bfa58f744a3	1	2024-09-07 01:11:57.532217	f
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

