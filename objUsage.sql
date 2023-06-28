WITH objUsage (objlib, objname, objtype, objattr, lastUsedDate, crtdate, objAge,
      Days_Used_ResetDate, days_used_counter, days_Available, usage_Percentage,
      objowner, objcreator, objsize, objtext) AS (
    SELECT cast(left(objlongschema,10) as varchar(10)),
           objname,
           objtype,
           objattribute,
           CAST(last_used_timestamp AS DATE) AS LastUsedDate,
           CAST(objcreated AS DATE) AS CrtDate,
           DAYS(current_date) - DAYS(objcreated) AS ObjAge,
           CAST(last_Reset_Timestamp AS DATE) AS UsageResetDate,
           days_used_count AS Days_Used,
           DAYS(current_date) -
             DAYS(COALESCE(last_Reset_timeStamp, objcreated)) + 1
             Days_Available,
           CAST(
             100.00 *
               (Dec(days_used_count, 7, 2) /
                 dec( 1 + DAYS(current_date) -
                      DAYS(COALESCE(last_Reset_timeStamp, objcreated)), 7, 2))
                AS DEC(5, 2)) Usage_Percentage,
           objowner,
           objDefiner,
           objsize,
           objtext
           
           -- Change the two parameters to '*ALLUSR' and '*ALL'
           -- to scan your entire system, otherwise change the
           -- Library and object type parameters as desired.
      FROM TABLE(object_statistics('PRODLIB', '*PGM *SRVPGM')) OL
  )
  SELECT *
    FROM objUsage
      -- Omit the ORDER BY clause to speed up the initial resultSet
    ORDER BY Usage_Percentage DESC,
             days_used_counter DESC,
             objlib,
             objname
             
