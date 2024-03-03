USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';

/*INFORMATION_SCHEMA is a virtual database in MySQL that provides access to metadata about the
 MySQL server and databases. It contains a set of read-only views and tables that provide information 
 about various aspects of the database system, such as database schemas, tables, columns, indexes, 
 privileges, and more. */









-- Q2. Which columns in the movie table have null values?
-- Type your code below:



SELECT 
    COUNT(id IS NULL OR NULL) AS ID_nulls, 
    COUNT(title IS NULL OR NULL) AS title_nulls, 
    COUNT(year IS NULL OR NULL) AS year_nulls,
    COUNT(date_published IS NULL OR NULL) AS date_published_nulls,
    COUNT(duration IS NULL OR NULL) AS duration_nulls,
    COUNT(country IS NULL OR NULL) AS country_nulls,
    COUNT(worlwide_gross_income IS NULL OR NULL) AS worlwide_gross_income_nulls,
    COUNT(languages IS NULL OR NULL) AS languages_nulls,
    COUNT(production_company IS NULL OR NULL) AS production_company_nulls
FROM movie;

/*the count function counts the number of null functions present in the each column
IS NULL checks if the value in the column is "NULL" 
NULL checks if the value is absent  and acts as a placeholder 
or condition helps the count operator to check both the ways and it returns true even if one condition is true.*/








-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT YEAR(date_published) AS release_year, COUNT(*) AS total_movies
FROM movie
WHERE date_published IS NOT NULL
GROUP BY release_year
ORDER BY release_year;

SELECT  MONTH(date_published) AS release_month, COUNT(*) AS total_movies
FROM movie
WHERE date_published IS NOT NULL
GROUP BY  release_month
ORDER BY  release_month;




/*These two SQL queries retrieve the count of movies released each year and each month, respectively, 
excluding any NULL values in the date_published column. They group the data by release year and release month,
calculate the total number of movies for each group, and order the results by release year or release month.*/






/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
SELECT COUNT(DISTINCT id) AS number_of_movies, year
FROM movie
WHERE (country LIKE '%USA%' OR country LIKE '%India%')AND year = 2019;


/*This query will count the number of distinct movie IDs for movies produced in either the 
USA or India (including variations) and published in the year 2019. 
It uses the LIKE operator with wildcard characters % to match any country names containing 'USA' or 'India' 
and filters the data based on the specified year in the date_published column.*/




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


SELECT DISTINCT genre 
FROM genre;

/*The DISTINCT keyword in SQL is used to unique values  from the column*/





/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT g.genre, COUNT(*) AS total_number_of_movies
FROM genre g
INNER JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY total_number_of_movies DESC
LIMIT 1;


/*we slect genere column and count the number of columns , 
we use g and m as aliases for genre and movies and then we do inner join with table movies where movie_id column
is taken to match/ combine the two table , then grouped by genre and orderd i ascending and
limit is applied as 1 to display the number one position*/





/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(*) AS single_genre_movies
FROM (
    SELECT movie_id, COUNT(*) AS genre_count
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(*) = 1
) AS single_genre_counts;


/*We use a subquery to count the number of genres associated with each movie. 
we group the result by movie ID (id) and use the HAVING clause to filter only those movies that
have exactly one genre associated to them Finally, we count the number of such 
movies to get the total count of movies belonging to only one genre.*/






/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT g.genre, ROUND(AVG(m.duration)) AS average_duration
FROM genre g
INNER JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY average_duration DESC;


/*We join the "genre" and "movie" tables using the common column movie_id.Then, 
we group the result by genre then  calculate the average duration of movies and order in ascending order 
ans we also round off the duration using the round function*/







/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH summary AS (
    SELECT genre,
           COUNT(movie_id) AS movie_count,
           RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank
    FROM genre
    GROUP BY genre
)
SELECT genre,
       movie_count,
       genre_rank
FROM summary
WHERE genre = 'thriller';


/*The Common Table Expression (CTE) summary calculates the count of movies and the rank for each genre.
The main query selects the genre, movie_count, and genre_rank from the summary.The result is then  
filtered to include only the 'thriller' genre using the WHERE clause.*/






/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;

/*This query calculates the minimum and maximum values for average rating,
 total votes, and median rating across all records in the "ratings" table, 
 providing insights into the range of these metrics within the dataset.*/



    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT movie_id, title, average_rating, RANK() OVER (ORDER BY average_rating DESC) AS ranking
FROM (
    SELECT m.id AS movie_id, m.title, AVG(r.avg_rating) AS average_rating
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    GROUP BY m.id, m.title
) AS average_ratings
ORDER BY ranking
LIMIT 10;

SELECT movie_id, title, average_rating, DENSE_RANK() OVER (ORDER BY average_rating DESC) AS ranking
FROM (
    SELECT m.id AS movie_id, m.title, AVG(r.avg_rating) AS average_rating
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    GROUP BY m.id, m.title
) AS average_ratings
ORDER BY ranking
LIMIT 10;


/*The inner query calculates the average rating for each movie, grouping by movie ID and title.
The outer query then selects movie ID, title, average rating, and uses the DENSE_RANK() and rank  
function to assign a ranking to each movie .Finally, the results are limited to the top 10 movies.*/


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating, COUNT(DISTINCT movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;


/*This query retrieves the distinct count of movies for each unique median rating from the "ratings" table, 
providing an overview of the distribution of movies based on their median ratings. 
The results are then ordered in descending order based on the movie count, revealing the most common median ratings 
along with the corresponding number of movies.*/







/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_summary AS (
    SELECT m.production_company,
           COUNT(m.id) AS movie_count,
           DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS production_company_rank
    FROM movie AS m
    INNER JOIN ratings AS r ON m.id = r.movie_id
    WHERE avg_rating > 8
          AND m.production_company IS NOT NULL
    GROUP BY m.production_company
)
SELECT *
FROM production_company_summary
WHERE  production_company_rank = 1;


/*The provided SQL code  calculates the number of movies produced by each production company
 with an average rating exceeding 8. inner join  joins the movie and ratings tables, filtering by the specified conditions 
 and assigning rankings to each production company based on their movie count. 
 The subsequent main query selects all columns  with the highest ranking*/




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:




SELECT g.genre, COUNT(*) AS movie_count
FROM movie m
 JOIN genre g ON g.movie_id = m.id
 JOIN ratings r ON r.movie_id = m.id
WHERE YEAR(m.date_published) = 2017
      AND MONTH(m.date_published) = 3
      AND r.total_votes > 1000
      AND m.country LIKE '%USA%'
GROUP BY g.genre
ORDER BY movie_count DESC;

/*This SQL query retrieves the count of movies for each genre released in March 2017 in the USA, with total votes exceeding 1000. 
It achieves this by joining the movie, genre, and ratings tables based on their respective IDs. 
conditions are applied to get the results to movies meeting the specified criteria regarding release date, total votes, and country. 
The results are then grouped by genre and ordered in descending order based on the movie count. */






-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT g.genre, m.title, r.avg_rating
FROM movie m
INNER JOIN genre g ON m.id = g.movie_id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE m.title LIKE 'The%'
      AND r.avg_rating > 8
ORDER BY avg_rating DESC;


/*This SQL query selects the genre, title, and average rating of movies that start with "The" and have an average 
 greater than 8. It combines data from the movie, genre, and ratings tables based on movie IDs. 
 The filter condition ensures only movies starting with "The" and having an average rating above 8 are included. 
The results are then sorted in descending order based on the average rating.*/








-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(*) AS movies_with_median_rating_8
FROM (
    SELECT m.id
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01' AND  median_rating = 8
    GROUP BY m.id
) AS median_rating_8_movies;


/*This SQL query counts the number of distinct movies that were published between April 1, 2018, and April 1, 2019, and 
have a median rating of exactly 8. It achieves this by first selecting movie IDs from the movie and 
ratings tables where the date of publication falls within the specified range and the median rating is 8. 
Then, it groups these movie IDs to ensure uniqueness and counts the resulting distinct movie IDs to 
determine the total number of movies meeting the criteria.*/






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT
    SUM(CASE WHEN m.country = 'Germany' THEN r.total_votes ELSE 0 END) AS total_votes_german_movies,
    SUM(CASE WHEN m.country = 'Italy' THEN r.total_votes ELSE 0 END) AS total_votes_italian_movies
FROM
    movie m
JOIN
    ratings r ON m.id = r.movie_id
WHERE
    m.country IN ('Germany', 'Italy');




/*This SQL query calculates the total votes for movies produced in Germany and Italy separately. 
It achieves this by summing up the total votes for movies from each country individually. 
The CASE statements conditionally select the total votes for each country, while the SUM function aggregates these votes. 
The JOIN operation combines data from the movie and ratings tables based on movie IDs, and the WHERE clause filters 
the movies to include only those produced in Germany or Italy.*/



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
    COUNT(*) - COUNT(name) AS name_nulls, 
    COUNT(*) - COUNT(height) AS height_nulls,
    COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls,
    COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls
FROM names;


/*This SQL query calculates the number of null values in the name, height, date_of_birth, 
and known_for_movies columns of the names table. It does so by subtracting the count of non-null values from 
the total count of rows for each column. 
This provides the count of null values in each column individually.*/



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



WITH top_three_genres AS (
    SELECT mg.genre, COUNT(m.id) AS movie_count,
           RANK() OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
    FROM movie m
    INNER JOIN genre mg ON m.id = mg.movie_id
    INNER JOIN ratings r ON m.id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY mg.genre
    LIMIT 3
)
SELECT n.name, COUNT(dm.movie_id) AS movie_count
FROM director_mapping dm
INNER JOIN names n ON dm.name_id = n.id
INNER JOIN genre mg ON dm.movie_id = mg.movie_id
INNER JOIN top_three_genres tg ON tg.genre = mg.genre
INNER JOIN ratings r ON dm.movie_id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 3;


/*This SQL query first identifies the top three genres with the highest counts of highly-rated movies (average rating > 8) 
Then, in the main query, it joins the director_mapping, names, genre, and ratings tables to retrieve details 
about directors, movies, genres, and ratings. conditions are applied to include only movies and directors 
with average ratings exceeding 8. The query calculates the count of movies directed by each director within the top 
three genres, grouping the results by director name. Finally, movie count in descending order and limits the output to the top 3 directors.*/











/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



SELECT n.name AS actor_name, COUNT(rm.movie_id) AS movie_count
FROM names n
INNER JOIN role_mapping rm ON rm.name_id = n.id
INNER JOIN ratings r ON r.movie_id = rm.movie_id
WHERE r.median_rating >= 8 AND rm.category = 'actor'
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;

/*his SQL query retrieves the top two actors based on the count of movies in which they've acted and that have a median rating
 of 8 or higher. It achieves this by joining the names, role_mapping, and ratings tables, filtering for actors and movies 
 meeting the specified rating criteria. The results are  sorted in descending order based on the movie count. 
 limits the output to the top 2 actors.*/











/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT m.production_company, SUM(r.total_votes) AS vote_count,
       DENSE_RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
GROUP BY m.production_company
ORDER BY vote_count DESC
LIMIT 3;

/*This SQL query calculates the total votes received by movies produced by each production company and assigns a rank to each production company based on the total vote count. 
It achieves this by joining the movie and ratings tables The DENSE_RANK() function is used to assign a rank to each 
production company based on the descending order of total vote counts.*/









/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_summary AS (
    SELECT N.NAME AS actor_name,
           COUNT(*) AS movie_count,
           ROUND(SUM(avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating
    FROM movie AS M
    INNER JOIN ratings AS R ON M.id = R.movie_id
    INNER JOIN role_mapping AS RM ON M.id = RM.movie_id
    INNER JOIN names AS N ON RM.name_id = N.id
    WHERE RM.category = 'ACTOR' AND M.country = 'India'
    GROUP BY N.NAME
    HAVING COUNT(R.movie_id) >= 5
)
SELECT *,
       RANK() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank
FROM actor_summary;



/*This SQL query calculates the summary statistics for actors from India, including their names, 
the number of movies they've acted in, and their average rating across those movies. 
It filters actors based on their category (ACTOR) and the country of production (India), 
ensuring that only actors with at least 5 movies are included. 
The results are then ranked based on the actors' average ratings in descending order.*/



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary AS (
    SELECT n.name,
           SUM(r.total_votes) AS total_votes,
           COUNT(m.id) AS movie_count,
           ROUND(SUM(avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating,
           RANK() OVER (ORDER BY ROUND(SUM(avg_rating * r.total_votes) / SUM(r.total_votes), 2) DESC) AS actress_rank
    FROM names n
    INNER JOIN role_mapping rm ON n.id = rm.name_id
    INNER JOIN movie m ON rm.movie_id = m.id
    INNER JOIN ratings r ON m.id = r.movie_id
    WHERE rm.category = 'ACTRESS' AND m.languages LIKE '%Hindi%' AND m.country = 'INDIA'
    GROUP BY n.name
    HAVING COUNT(m.id) >= 3
)
SELECT name as actress_name, total_votes, movie_count, actress_avg_rating, actress_rank
FROM actress_summary
LIMIT 5;


/*This SQL query generates a summary of actresses from India who have acted in at least three Hindi-language movies. 
It calculates statistics including the actress's name, total votes received for their movies, the count of movies 
they've appeared in, their average rating across those movies, and their rank based on this average rating. 
The data is obtained by joining the names, role_mapping, movie, and ratings tables, filtering for actresses, 
Hindi-language movies, and movies produced in India. Top 5 are given as output*/





/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:



WITH thriller_movies AS (
   SELECT m.title, r.avg_rating
   FROM movie AS m 
   INNER JOIN genre AS g ON g.movie_id = m.id 
   INNER JOIN ratings AS r ON r.movie_id = m.id 
   WHERE g.genre LIKE '%Thriller%' 
   GROUP BY m.title, r.avg_rating
)
SELECT title, avg_rating,
   CASE
      WHEN avg_rating > 8 THEN 'Superhit movies' 
      WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies' 
      WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies' 
      ELSE 'Flop movies'
   END AS avg_rating_category 
FROM thriller_movies;


/*
This SQL query categorizes thriller movies based on their average ratings into different categories: 
  Then, it categorizes these movies based on their average ratings using a CASE statement.
 Finally, it retrieves the movie title, average rating, and the corresponding rating category for each thriller movie.*/



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:



WITH genre_avg_duration AS (
    SELECT 
        g.genre AS genre,
        AVG(m.duration) AS average_duration
    FROM 
        movie m
    JOIN genre g ON m.id = g.movie_id
    GROUP BY 
        g.genre
)
SELECT 
    genre,
    ROUND(AVG(average_duration), 2) AS average_duration,
    ROUND(SUM(AVG(average_duration)) OVER (PARTITION BY genre ORDER BY genre), 2) AS running_total,
    ROUND(AVG(average_duration) OVER (PARTITION BY genre ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS moving_average
FROM 
    genre_avg_duration
GROUP BY 
    genre;


/*This SQL query calculates the average duration, running total, and moving average duration for each movie genre. 
It first calculates the average duration for each genre in the genre_avg_duration Common Table Expression (CTE). 
Then, in the main query, it selects the genre, rounding the average duration to two decimal places. 
It calculates the running total of average durations for each genre and also computes the moving average duration, 
 Finally, the results are grouped by genre.*/







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genre AS
( 	
	SELECT genre, COUNT(movie_id) AS number_of_movies
    FROM genre AS g
    INNER JOIN movie AS m
    ON g.movie_id = m.id
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),

top_5 AS
(
	SELECT genre,
			year,
			title AS movie_name,
			worlwide_gross_income,
			DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
        
	FROM movie AS m 
    INNER JOIN genre AS g 
    ON m.id= g.movie_id
	WHERE genre IN (SELECT genre FROM top_3_genre)
)

SELECT *
FROM top_5
WHERE movie_rank<=5;


/*
This SQL query aims to identify the top 5 movies in each year within the top 3 genres with the highest number of movies. 
It first determines the top 3 genres based on movie count, then selects movies belonging to these genres and 
ranks them by worldwide gross income within each year. Finally, it retrieves the details of these top-ranking movies,
 ensuring that only the top 5 movies in each year and genre combination are included in the final result.*/








-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:




WITH production_company_summ
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM   movie AS m
                inner join ratings AS r
                        ON r.movie_id = m.id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,
       Rank()
         over(
           ORDER BY movie_count DESC) AS prod_comp_rank
FROM   production_company_summ
LIMIT 2; 


/*
This SQL query calculates the total count of movies produced by each production company, 
considering only those with a median rating of 8 or higher, where the production company information is not null,
 and the languages include a comma. It groups the results by production company and assigns a rank to each company 
 based on the movie count.*/




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:






WITH actress_rank AS (
    SELECT
        n.name AS actress_name,
        COUNT(m.id) AS movie_count,
        SUM(r.total_votes) AS total_votes,
        ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating,
        DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS actress_rank
    FROM 
        movie m 
    INNER JOIN 
        role_mapping rm ON rm.movie_id = m.id 
    INNER JOIN 
        names n ON n.id = rm.name_id 
    INNER JOIN 
        ratings r ON r.movie_id = m.id 
    INNER JOIN 
        genre g ON g.movie_id = m.id 
    WHERE 
        rm.category = 'actress' 
        AND r.avg_rating > 8 
        AND g.genre = 'drama' 
    GROUP BY 
        actress_name
)
SELECT 
    actress_name,
    movie_count,
    total_votes,
    actress_avg_rating,
    actress_rank
FROM 
    actress_rank
LIMIT 3;


/*This SQL query computes the ranking and relevant statistics for actresses who have appeared in drama movies with an 
average rating above 8. It aggregates data from the movie, role_mapping, names, ratings, and genre tables, 
filtering for actresses in drama movies with high ratings. The results include the actress's name, count of movies 
she has appeared in, total votes received across those movies, her average rating, and her rank based on the 
count of movies she has acted in.*/

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH movie_date_info AS (
    SELECT 
        d.name_id, 
        n.name, 
        d.movie_id,
        m.date_published, 
        LEAD(m.date_published, 1) OVER (PARTITION BY d.name_id ORDER BY m.date_published, d.movie_id) AS next_movie_date
    FROM 
        director_mapping d
    JOIN 
        names n ON d.name_id = n.id 
    JOIN 
        movie m ON d.movie_id = m.id
),
date_difference AS (
    SELECT 
        *,
        DATEDIFF(next_movie_date, date_published) AS diff
    FROM 
        movie_date_info
),
avg_inter_days AS (
    SELECT 
        name_id, 
        AVG(diff) AS avg_inter_movie_days
    FROM 
        date_difference
    GROUP BY 
        name_id
),
final_result AS (
    SELECT 
        d.name_id AS director_id,
        name AS director_name,
        COUNT(d.movie_id) AS number_of_movies,
        ROUND(AVG(avg_rating), 2) AS avg_rating,
        SUM(total_votes) AS total_votes,
        MIN(avg_rating) AS min_rating,
        MAX(avg_rating) AS max_rating,
        SUM(duration) AS total_duration,
        ROUND(AVG(avg_inter_movie_days), 2) AS inter_movie_days,
        ROW_NUMBER() OVER (ORDER BY COUNT(d.movie_id) DESC) AS director_row_rank
    FROM
        names n 
    JOIN 
        director_mapping d ON n.id = d.name_id
    JOIN 
        ratings r ON d.movie_id = r.movie_id
    JOIN 
        movie m ON m.id = r.movie_id
    JOIN 
        avg_inter_days a ON a.name_id = d.name_id
    GROUP BY 
        director_id, director_name
)
SELECT 
    director_id,
    director_name,
    number_of_movies,
    inter_movie_days,
    avg_rating,
    total_votes,
    min_rating,
    max_rating,
    total_duration
FROM 
    final_result
LIMIT 9;

/*This SQL query calculates various statistics for directors, including the number of movies they've directed,
 the average time between their movie releases, the average rating of their movies, the total number of votes received, 
 and the duration of all their movies. It groups the data by director, aggregates movie-related information,
  and computes the necessary metrics. Finally, it presents the details for the top 9 directors based on the count of movies directed.*/