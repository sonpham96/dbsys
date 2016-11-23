---- PART 3: STORE PROCUDURE, FUNCTION (2p)
-- Question 1:
CREATE OR REPLACE FUNCTION insertEmployee
(	
	firstNname IN VARCHAR(20),
	lastName IN VARCHAR(20),
	phone IN VARCHAR(11),
	address IN VARCHAR(50),
	isSalesMan IN NUMBER(1),
	regNumber IN INT
)
RETURN returnValue NUMBER(1)
AS
employeeCode CHAR(5);
BEGIN
	IF isSalesMan = 1
	THEN
		-- Insert Sales man
		INSERT INTO EMPLOYEE (FName, LName, Phone, Address, IsSalesMan, IsShipper, RegNumber)
		OUTPUT Inserted.Ecode INTO employeeCode
		VALUES (firstNname, lastName, phone, address, 1, 0, NULL);
	ESLE
		-- Insert Shipper
		INSERT INTO EMPLOYEE (FName, LName, Phone, Address, IsSalesMan, IsShipper, RegNumber)
		OUTPUT Inserted.Ecode INTO employeeCode
		VALUES (firstNname, lastName, phone, address, 0, 1, regNumber);
	END IF;

	IF employeeCode = NULL
	THEN
		returnValue = 0;
		raise_application_error (-20999, 'Insert employee fail!');
	ELSE returnValue = 1;
	END IF;

	RETURN;
END;

-- Question 2:
CREATE OR REPLACE FUNCTION getTop3Pizza
(
	startDate IN DATE,
	endDate IN DATE
)
AS
RETURN retrunTable TABLE
BEGIN
	-- Handle if endDate is NULL
	IF endDate = NULL
	THEN SELECT SYSDATE INTO endDate;
	END IF;

	-- Get orders in date range
	SELECT ORDER_.OID INTO inDateRangeOrders
	FROM ORDER_
	WHERE startDate < ORDER_.DATE AND ORDER_.DATE < endDate;

	-- Get pizza count
	SELECT PID, COUNT(*) AS COUNT INTO pizzaCount
	FROM ORDERED_PIZZA
	WHERE OID IN inRangeOrders
	ORDER BY COUNT ASC
	GROUP BY PID;

	-- Get 3 top pizza
	SELECT * INTO pizzaCount
	FROM pizzaCount
	WHERE ROWNUM <= 3

	-- Get return table
	SELECT pizzaCount.PID, PIZZA.Name INTO retrunTable
	FROM pizzaCount, PIZZA
	WHERE pizzaCount.PID = PIZZA.PID;

	RETURN;
END;
