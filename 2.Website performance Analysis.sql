#Website performance Analysis
/*To understand which pages are seen the most by users, to identify where to focus on improving the business
USE CASES:-
1. Fingind most viewed pages by the customers.
2. Identifying the most common entry pages to the website- the first thing a users sees
3.for above 2 cases, understanding how those pages perform the business objectives.
*/

USE MAVENFUZZYFACTORY;
SELECT * FROM WEBSITE_PAGEVIEWS WHERE WEBSITE_PAGEVIEW_ID < 1000;

# TASK 1- ANALYSING TOP WEBSITE PAGES- MOST VIEWED PAGES

SELECT PAGEVIEW_URL, COUNT(DISTINCT WEBSITE_PAGEVIEW_ID) AS PAGEVIEW
FROM WEBSITE_PAGEVIEWS WHERE WEBSITE_PAGEVIEW_ID < 1000
GROUP BY PAGEVIEW_URL
ORDER BY PAGEVIEW DESC;

# TASK 2- TOP ENTRY PAGES
CREATE TEMPORARY TABLE FIRST_PAGEVIEW
SELECT 
    WEBSITE_SESSION_ID, MIN(WEBSITE_PAGEVIEW_ID) AS MIN_PV_ID
FROM
    WEBSITE_PAGEVIEWS
WHERE
    WEBSITE_PAGEVIEW_ID < 1000
GROUP BY WEBSITE_SESSION_ID;


SELECT 
    WEBSITE_PAGEVIEWS.PAGEVIEW_URL AS LANDING_PAGE,
    COUNT(DISTINCT FIRST_PAGEVIEW.WEBSITE_SESSION_ID) AS SESSIONS_HITTING_THIS_LANDER
FROM
    FIRST_PAGEVIEW
        LEFT JOIN
    WEBSITE_PAGEVIEWS ON FIRST_PAGEVIEW.MIN_PV_ID = WEBSITE_PAGEVIEWS.WEBSITE_PAGEVIEW_ID
GROUP BY WEBSITE_PAGEVIEWS.PAGEVIEW_URL;

# TAST 3- MOST VIEWED WEBSITE PAGES RANKED BY SESSION VOLUME

SELECT PAGEVIEW_URL, COUNT(DISTINCT WEBSITE_PAGEVIEW_ID) AS PVS
FROM WEBSITE_PAGEVIEWS WHERE CREATED_AT < '2012-06-09'
GROUP BY PAGEVIEW_URL
ORDER BY PVS DESC;

#TASK 4- PULL ALL ENTRY PAGES AND RANK THEM ON ENTRY VOLUME.
--  Step 1: Find the first pageview for each session
-- Step 2: Find the url the customer saw on that first pageview

CREATE TEMPORARY TABLE FIRST_PV_PER_SESSION
SELECT 
    WEBSITE_SESSION_ID, MIN(WEBSITE_PAGEVIEW_ID) AS FIRST_PV
FROM
    WEBSITE_PAGEVIEWS
WHERE
    CREATED_AT < '2012-06-12'
GROUP BY WEBSITE_SESSION_ID;

SELECT 
    WEBSITE_PAGEVIEWS.PAGEVIEW_URL AS LANDING_PAGE_URL,
    COUNT(DISTINCT FIRST_PV_PER_SESSION.WEBSITE_SESSION_ID) AS SESSIONS_HITTING_PAGE
FROM
    FIRST_PV_PER_SESSION
        LEFT JOIN
    WEBSITE_PAGEVIEWS ON FIRST_PV_PER_SESSION.FIRST_PV = WEBSITE_PAGEVIEWS.WEBSITE_PAGEVIEW_ID
GROUP BY WEBSITE_PAGEVIEWS.PAGEVIEW_URL;

#LANDING PAGE PERFORMANCE & TESTING- Performance of key landing page and then testing to improve the results

/* 
A/B Testing--- helps to compare the performance of 2 versions of website (eg) and helps to optimize business.
Home (PAGE A)---> CART----> checkout (85% of ppl)
Home (PAGE B)---> CART----> checkout (92% of ppl)
To find first pageview for relevant sessions, associate that pageview with url seen, then analyse whether that session has additional pageviews.
if only 1 page view ( bounced), multiple pageview (non bouncesd)
*/

-- STEP 1 : Find the first website_pageview_id for relevaht sessions
-- STEP 2 : Identify the landing page for each session
-- STEP 3: Counting pageviews for each session, to identify "bounces" if there is more than 1 page visited
-- STEP 4: Summarizing the total session and bonced sessions.


-- Finding the minimum website pageview id associated with each session we care 
SELECT 
    WEBSITE_PAGEVIEWS.WEBSITE_SESSION_ID,
    MIN(WEBSITE_PAGEVIEWS.WEBSITE_PAGEVIEW_ID) AS MIN_PAGEVIEW_ID
FROM
    WEBSITE_PAGEVIEWS
INNER JOIN WEBSITE_SESSIONS 
ON WEBSITE_SESSIONS.WEBSITE_SESSION_ID = WEBSITE_PAGEVIEWS.WEBSITE_SESSION_ID
AND WEBSITE_SESSIONS.CREATED_AT BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY WEBSITE_PAGEVIEWS.WEBSITE_SESSION_ID;	

-- same querry as above but creating a temporary table
CREATE TEMPORARY TABLE FIRST_PAGEVIEWS_DEMO
SELECT 
    WEBSITE_PAGEVIEWS.WEBSITE_SESSION_ID,
    MIN(WEBSITE_PAGEVIEWS.WEBSITE_PAGEVIEW_ID) AS MIN_PAGEVIEW_ID
FROM
    WEBSITE_PAGEVIEWS
INNER JOIN WEBSITE_SESSIONS 
ON WEBSITE_SESSIONS.WEBSITE_SESSION_ID = WEBSITE_PAGEVIEWS.WEBSITE_SESSION_ID
AND WEBSITE_SESSIONS.CREATED_AT BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY WEBSITE_PAGEVIEWS.WEBSITE_SESSION_ID;


SELECT * FROM FIRST_PAGEVIEWS_DEMO;

# TO PULL THE BOUNCE RATE FOR TRAFFIC LANDING ON HOMEPAGE. (OP- SESSION, BOUNCED_SESSION, BOUNCE_RATE)


#CONVERSION FUNNELS- ANALYZING AND TESTING
# Understanding and analysing each step of user experience on their journey toward purchasing the products;
/*
-- Identify most common paths customers take before purchasing products.
-- Identlfy how many customers drop out at what step and ho many custiners reach final stage.
-- optimizing critical point where users are abondoning and improving busines by converting more users and selling more products.
*/

SELECT website_sessions.website_session_id,
website_pageviews.pageview_url,
website_pageviews.created_at AS pageview_created_at, 
CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions
LEFT JOIN website_pageviews
ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- random timeframe for demo
AND website_pageviews.pageview_url IN ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
ORDER BY
website_sessions.website_session_id, website_pageviews.created_at;













