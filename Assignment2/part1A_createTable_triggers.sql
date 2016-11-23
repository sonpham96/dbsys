--EMPLOYEE ECODE CONSTRAINT--
CREATE SEQUENCE emp_sm_seq START WITH 1; 
CREATE SEQUENCE emp_sp_seq START WITH 1;
CREATE OR REPLACE TRIGGER trg_emp_ecode
BEFORE INSERT OR UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
  IF inserting
  THEN
    IF (:new.IsSalesMan = 1) 
    THEN
      SELECT 'SM' || lpad(emp_sm_seq.NEXTVAL, 3, 0) INTO :new.ECode FROM dual;
      
    ELSE
      SELECT 'SP' || lpad(emp_sp_seq.NEXTVAL, 3, 0) INTO :new.ECode FROM dual;
    END IF;
  END IF;
  IF updating
  THEN
    SELECT :old.ECode INTO :new.ECode FROM dual;
  END IF;
END;
-----------------------------

--EMPLOYEE DELIVERYTIME DEFAULT VALUE--
CREATE OR REPLACE TRIGGER trg_order_deliverytime
BEFORE INSERT ON ORDER_
FOR EACH ROW
WHEN (new.DeliveryTime IS NULL)
BEGIN
  SELECT :new.OrderTime + 30/1440 INTO :new.DeliveryTime FROM dual;
END;
-----------------------------
