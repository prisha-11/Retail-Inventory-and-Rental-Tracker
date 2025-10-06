# Sustainable-Closet-Tracker
To create a Database Management System (DBMS) application that enables users to accurately catalog their clothing inventory, log the usage frequency of each item, and generate actionable recommendations that encourage users to wear less-used items, thereby promoting greater longevity of garments and supporting sustainable fashion practices.

Sustainable Wardrobe Tracker: Promoting Conscious Consumption
1. Project Overview
The Sustainable Wardrobe Tracker is a Database Management System (DBMS) application designed to combat the negative effects of "fast fashion" by increasing the utility and lifespan of clothing items already owned by consumers.

The core goal is to provide users with visibility and actionable insights into their clothing usage. By tracking item usage and identifying underutilized garments, the application encourages users to maximize the value of their existing wardrobe, ultimately promoting sustainable fashion practices and reducing textile waste.

2. Key Features
The application's functionality is built directly upon the robust data model to deliver the following features:

Inventory Management
Comprehensive Cataloging: Allows users to input detailed metadata for each item (purchase date, price, brand, color, material, category).

Archiving: Users can mark items as archived (donated, sold, or discarded) to maintain an accurate active wardrobe count.

Usage Tracking
Efficient Wear Logging: A simple mechanism to log all items worn on a specific date in a single, time-stamped Wear Event.

Usage Count Tracking: Automated tracking of the total number of times each item has been worn.

Sustainability and Analytics
Cost-Per-Wear (CPW) Calculation: Automatically calculates the CPW= 
Usage Count
Initial Price
​
  for every item, providing a tangible metric of item value and sustainability.

Recommendation Engine: Generates prioritized lists of underutilized items (e.g., unworn for 90+ days), encouraging users to wear them.

Usage Dashboard: Visual display of key sustainability metrics, such as unique items worn, average CPW across the wardrobe, and total inventory value.

3. Data Model Architecture Overview
The application utilizes a relational database structure designed to handle the critical Many-to-Many relationship between individual Items and Wear Events.

Core Entities:
USER: The primary account, responsible for data ownership.

CATEGORY: A lookup table for organizing the wardrobe (e.g., Tops, Bottoms).

ITEM: The central entity, representing a single piece of clothing with its purchase details.

WEAR_EVENT: Represents a specific date/occasion when an outfit was worn.

ITEM_WEAR_LOG: The junction table that links specific ITEMs to specific WEAR_EVENTs, serving as the source of truth for all usage analytics.

Key Relationship
The analytical power of the application relies on the ITEM_WEAR_LOG table, which resolves the M:M relationship, allowing for complex queries to calculate usage frequency and duration since last worn.

4. Database Schema Reference (MySQL)
The detailed physical schema, including data types, primary keys, foreign keys, and unique constraints, is defined in the wardrobe_schema.sql file.

Primary Tables and Relationships:

<img width="451" height="267" alt="image" src="https://github.com/user-attachments/assets/72b03417-d09d-4869-a31b-c0a13d4052df" />

5. Development and Setup
Prerequisites
[Database System] (e.g., MySQL, PostgreSQL, or Firestore implementation for web apps)

[Backend Framework] (e.g., Node.js/Express, Python/Django)

[Frontend Framework] (e.g., React, Angular, Vue.js)

Installation Steps (Placeholder)
Clone the repository: git clone [repository-url]

Set up the database connection in config.js or equivalent.

Run the schema creation script: mysql -u user -p < wardrobe_schema.sql

Install dependencies: npm install (or equivalent)

Start the application: npm start
