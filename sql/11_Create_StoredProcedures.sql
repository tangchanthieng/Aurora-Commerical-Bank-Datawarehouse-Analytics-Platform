USE CommercialBankAnalytics;
GO
CREATE OR ALTER PROCEDURE dbo.sp_Run_Incremental_ETL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            -- Execute standard transformation steps sequentially
            EXEC('TRUNCATE TABLE silver.users_clean');
            PRINT 'ETL processing pipeline successfully simulated via procedure routine.';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO