/*
The database scheme consists of four tables:
Product(maker, model, type)
PC(code, model, speed, ram, hd, cd, price)
Laptop(code, model, speed, ram, hd, screen, price)
Printer(code, model, color, type, price)
The Product table contains data on the maker, model number, and type of product ('PC', 'Laptop', or 'Printer').
It is assumed that model numbers in the Product table are unique for all makers and product types.
Each personal computer in the PC table is unambiguously identified by a unique code, and is additionally characterized by its model (foreign key referring to the Product table), processor speed (in MHz) – speed field, RAM capacity (in Mb) - ram, hard disk drive capacity (in Gb) – hd, CD-ROM speed (e.g, '4x') - cd, and its price.
The Laptop table is similar to the PC table, except that instead of the CD-ROM speed, it contains the screen size (in inches) – screen.
For each printer model in the Printer table, its output type (‘y’ for color and ‘n’ for monochrome) – color field, printing technology ('Laser', 'Jet', or 'Matrix') – type, and price are specified.
*/


/* 1)
Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
Result set: model, speed, hd. */
SELECT model, speed, hd FROM PC
WHERE price<500;

/* 2)
List all printer makers. Result set: maker. */
SELECT DISTINCT maker
FROM Product
WHERE type = 'Printer'

/* 3)
Find the model number, RAM and screen size of the laptops with prices over $1000. */
SELECT model, ram, screen FROM Laptop
WHERE price > 1000;

/* 4)
Find all records from the Printer table containing data about color printers. */
SELECT code, model, color, type, price FROM Printer
WHERE color = 'y';

/* 5)
Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive. */
SELECT model, speed, hd FROM PC
WHERE price < 600 AND cd IN ('12x', '24x');

/* 6)
For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed. */
SELECT DISTINCT maker AS Maker, speed
FROM Product JOIN Laptop ON Product.model=Laptop.model
WHERE UPPER(Product.type) = 'LAPTOP' AND Laptop.hd >= 10;

/* 7)
Get the models and prices for all commercially available products (of any type) produced by maker B. */
SELECT model, price FROM
    (SELECT Product.maker, Product.model, PC.price
    FROM Product JOIN PC ON Product.model=PC.model
    UNION
    SELECT Product.maker,Product.model, Laptop.price
    FROM Product JOIN Laptop ON Product.model=Laptop.model
    UNION
    SELECT Product.maker, Product.model, Printer.price
    FROM Product JOIN Printer ON Product.model=Printer.model) sub
WHERE upper(maker) = 'B';

/* 8)
Find the makers producing PCs but not laptops. */
SELECT DISTINCT maker FROM Product WHERE maker NOT IN
(SELECT maker FROM Product WHERE type = 'Laptop')
AND type = 'PC';

SELECT Product.maker  from Product
WHERE type = 'PC'
EXCEPT
SELECT Product.maker  from Product
WHERE type = 'Laptop';

/* 9)
Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker. */
SELECT DISTINCT maker FROM Product
JOIN PC ON Product.model = PC.model
WHERE PC.speed >= 450;

/* 10)
Find the printer models having the highest price. Result set: model, price. */
SELECT model, price FROM Printer
WHERE price >=
    (SELECT MAX (price) AS price
    FROM Printer);

/* 11)
Find out the average speed of PCs. */
SELECT AVG(speed) FROM PC;

/* 12)
Find out the average speed of the laptops priced over $1000. */
SELECT AVG(speed) FROM Laptop
WHERE price > 1000;

/* 13)
Find out the average speed of the PCs produced by maker A. */
SELECT AVG(PC.speed) AS Avg_speed FROM PC
JOIN Product ON PC.model=Product.model
WHERE Product.maker='A';

/* 14)
For the ships in the Ships table that have at least 10 guns, get the class, name, and country. */
SELECT classes.class, ships.name, classes.country FROM ships
JOIN classes ON ships.class = classes.class
WHERE numGuns > 9;

/* 15)
Get hard drive capacities that are identical for two or more PCs.
Result set: hd. */
SELECT hd FROM PC
GROUP BY hd
HAVING COUNT(*) > 1;

/* 16)
Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
Result set: model with the bigger number, model with the smaller number, speed, and RAM */
SELECT pc1.model, pc2.model, pc1.speed, pc1.ram
FROM PC pc1, PC pc2
WHERE pc1.speed = pc2.speed
AND pc1.ram = pc2.ram
GROUP BY pc1.speed, pc1.ram, pc1.model, pc2.model
HAVING pc1.model > pc2.model;

/* 17)
Get the laptop models that have a speed smaller than the speed of any PC.
Result set: type, model, speed. */
SELECT DISTINCT p.type, l.model, l.speed
FROM Laptop l, Product p
WHERE l.speed < (SELECT MIN(speed) FROM PC)
AND p.type = 'Laptop'

/* 18)
Find the makers of the cheapest color printers.
Result set: maker, price. */
SELECT DISTINCT p1.maker, p2.price
FROM Product p1
JOIN Printer p2
ON p1.model = p2.model
WHERE p2.price = (SELECT MIN(price) FROM printer WHERE color='y')
AND color='y';

/* 19)
For each maker having models in the Laptop table, find out the average screen size of the laptops he produces.
Result set: maker, average screen size. */
SELECT p.maker, AVG(l.screen)
FROM product p
JOIN laptop l on p.model=l.model
GROUP BY p.maker;

/* 20)
Find the makers producing at least three distinct models of PCs.
Result set: maker, number of PC models. */
SELECT maker, COUNT(DISTINCT model) FROM product
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(DISTINCT model) >= 3;





















