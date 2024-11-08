---
slug: sql-daily-record
datetime: 2024-11-08 10:31
summary: SQL日常记录包含基础SQL操作如DML、DDL，数据类型介绍，约束设置，修改名称及查看SQL Server版本的方式，以及深圳中心大屏关键数据验证的示例。
tags: SQL, 数据类型, 约束
cover_image_url: ""
---
# SQL日常记录

## 一、SQL基础

### 1. SQL常规语句

![SQL分类](assets/SQL日常记录/SQL分类.png)

* `DML`增删改：

  ```SQL
  /* 新增 */
  INSERT INTO 表名[(列名1,…)] VALUES (列值1,…)
  
  /* 删除 */
  DELETE FROM 表名 [WHERE 条件];
  
  /* 修改 */
  -- 格式1：
  UPDATE 表名 [别名]
  SET 列名 = 表达式, ...
  [WHERE 条件];
  
  -- 格式2：
  UPDATE 表名 [别名]
  SET (列名, ...) = (子查询)
  [WHERE 条件];
  ```

* `DDL`创建数据库、数据表：

  ```SQL
  -- 在创建表前需要先创建数据库
  CREATE DATABASE <数据库名称>;
  ```

  ```SQL
  -- 创建表
  CREATE TABLE <表名> (
   <列名1> <数据类型> <该列所需约束>,
   <列名2> <数据类型> <该列所需约束>,
   <列名3> <数据类型> <该列所需约束>,
   <列名4> <数据类型> <该列所需约束>,
                 ...
   <该表的约束1>, <该表的约束2>，……)
  ```

  约束可以在定义列的时候进行设置（**对列的约束**），也可以在语句的末尾进行设置 （**主键约束/副键约束**）

  例如：

  ```SQL
  -- 创建课程表
  CREATE TABLE SC (
      sno CHAR(6) NOT NULL,
      Cno CHAR(6) NOT NULL,
      Grade SMALLINT DEFAULT NULL
  )
  PRIMARY KEY (sno,Cno)
  FOREIGN KEY (sno) REFERENCES student(sno)
  FOREIGN KEY (Cno) REFERENCES Course(Cno)
  CHECK (Grade BETWEEN 0 AND 100);
  ```

  如果在创建表时没有定义对列的约束，则是采用NULL(可以为空，不是一定为空)，但现在还有采用DEFAULT这种默认约束的。

- `DDL`删除与更新表：

  ```SQL
  -- 删除表
  DROP TABLE <表名>；
  DROP TABLE Product;
  
  -- 更新表: 向表中添加列
  ALTER TABLE <表名> ADD <列名> ；
  ALTER TABLE Product ADD product_name_pinyin VARCHAR(100),product_cy CHAR(10);
  
  -- 更新表: 在表中删除列
  ALTER TABLE <表名> DROP COLUMN <列名>；
  ALTER TABLE Product DROP COLUMN product_name_pinyin,product_cy;
  ```

- `DDL`创建与删除索引：

  * **创建唯一索引**

    - 对于已含重复值的属性列不能建UNIQUE索引；

    - 对某个列建立UNIQUE索引后，插入新记录时DBMS会自动检查新记录在该列上是否取了重复值。这相当于增加了一个UNIQUE约束。

    ```SQL
    CREATE UNIQUE INDEX Stusno ON Student(Sno ASC);
    ```

  - **创建聚簇索引**

    * 建立聚簇索引后，基表中数据也需要按指定的聚簇属性值的升序或降序存放。即聚簇索引的索引项顺序与表中记录的物理顺序一致。

    ```SQL
    CREATE CLUSTER INDEX Stusname ON Student(Sname);
    ```

  - **删除索引**

    ```SQL
    DROP INDEX [表名.]<索引名>;
    DROP INDEX Student.Stusname;
    ```
  
- 复制数据表：

  - 复制表结构及数据到新表

    ```sql
    CREATE TABLE new_table SELECT * FROM old_table
    ```

  - 只复制表结构到新表

    ```sql
    CREATE TABLE new_table SELECT * FROM old_table WHERE 1=2
    ```

    ```SQL
    CREATE TABLE new_table LIKE old_table
    ```

  - 复制旧表的数据到新表

    - 假设两个表结构一样

      ```sql
      INSERT INTO new_table SELECT * FROM old_table
      ```

    - 假设两个表结构不一样

      ```sql
      INSERT INTO new_table(a, b, ...) SELECT a, b, ... FROM old_table
      ```

  - 将表1结构复制到表2

    ```SQL
    SELECT * INTO table_2 FROM table_1 WHERE 1=2
    ```

  - 将表1全部内容复制到表2

    ```sql
    SELECT * INTO table_2 FROM table_1
    ```

  - 列出旧表创建命令

    ```sql
    SHOW CREATE TABLE old_table
    ```


### 2. 数据类型

- **INTEGER**型：
  用来指定存储整数的列的数据类型（数字型），不能存储小数。

- **CHAR**型：
  用来指定存储字符串的列的数据类型（字符型）。

  可以像 CHAR(10) 或者 CHAR(200) 这样，在括号中指定该列可以存储的字符串的长度（最大长度）。

  字符串超出最大长度的部分是无法输入到该列中的，该字符串是定长字符串，就是当列中存储的字符串长度达不到最大长度的时候，使用半角空格进行补足。

  例如，我们向 CHAR(8) 类型的列中输入 'abc’的时候，会以 'abc '（abc 后面有 5 个半角空格）的形式保存起来。

- **VARCHAR**型：
  该类型的列是以可变长字符串  的形式来保存字符串的。

  例如，我们向 VARCHAR(8) 类型的列中输入字符串 ‘abc’ 的时候，保存的就是字符串 ‘abc’。

- **DATE**型：
  用来指定存储日期（年月日）的列的数据类型（日期型）。

### 3. 约束的设置

- 约束是除了数据类型之外，对列中存储的数据进行限制或者追加条件的功能。

- 通过主键约束可以找到需要的列（该列是唯一的有且只有一个）。

如Product 表中设置了两种约束：

1. 列约束：

   ```sql
   product_id CHAR(4) NOT NULL,
   product_name VARCHAR(100) NOT NULL,
   product_type VARCHAR(32) NOT NULL,
   ```

2. 主键约束:

   ```sql
   PRIMARY KEY (product_id)
   ```

### 4. 修改名称

- 手动重命名

* `sp_rename`更改当前数据库中用户创建的对象（如表，列或用户定义数据类型）的名称：

  ```SQL
  exec sp_rename 'Product', 'Poduct'; --重命名表
  exec sp_rename 'Poduct.[product_id]','id','column';-- 改变字段名。
  ```

### 5. 查看SQL SERVER版本

```sql
exec xp_msver
```

![SQLSERVER版本](assets/SQL日常记录/SQLSERVER版本.png)

## 二、数据验证

### 1. 深圳中心大屏关键数据验证

```sql
/*****************************************
 ** 创建人：TANGWY
 ** 作用：对深圳中心大屏关键数据进行验证
********************************************/

-- 1. 总场次计算
SELECT COUNT([RoundId]) AS [TotalRound]
FROM [YZC_TZ].[dbo].[RoundInfo]
WHERE [Date] = '2024-08-29'
;

-- 2. 计算等待时长中值
WITH [RowNums] AS(
	SELECT [WaitTimeLength]
		, ROW_NUMBER() OVER (ORDER BY [WaitTimeLength]) AS [RowNum]
		, COUNT(*) OVER() as [TotalRows]
	FROM [NWBT_YT].[dbo].[DA_RoundInfo]
	WHERE [Date] = '2024-09-25'
)
SELECT 
    CASE 
		WHEN MAX([TotalRows]) % 2 = 1
		THEN MAX([WaitTimeLength])/60.00 -- 奇数行: 返回中间的一个值
		ELSE AVG([WaitTimeLength])/60.00 -- 偶数行: 返回中间两个值的平均值
    END AS [Median]
FROM [RowNums]
WHERE [RowNum] IN (([TotalRows] + 1) / 2, ([TotalRows] / 2) + 1);
;

-- 3. 计算飞翔接待时长中值(旧版：计算飞翔操作第二步)
WITH [RowNums] AS(
	SELECT [OperateTimeLength]
		, ROW_NUMBER() OVER (ORDER BY [OperateTimeLength]) AS [RowNum]
		, COUNT(*) OVER() as [TotalRows]
	FROM [FX_ZG].[dbo].[RoundProcedureInfo]
	WHERE [Date] = '2024-08-30' AND [ProcedureId] = 2
)
SELECT AVG([OperateTimeLength]) AS Median
FROM RowNums
WHERE RowNum IN (TotalRows/2, TotalRows/2+1, (TotalRows+1)/2)
;

-- 新版：计算飞翔场次运行时长中值
WITH [RowNums] AS(
	SELECT [TimeLength]
		, ROW_NUMBER() OVER (ORDER BY [TimeLength]) AS [RowNum]
		, COUNT(*) OVER() AS [TotalRows]
	FROM [FX_YT].[dbo].[DA_RoundInfo]
	WHERE [Date] = '2024-09-25'
)
SELECT 
    CASE 
		WHEN MAX([TotalRows]) % 2 = 1
		THEN MAX([TimeLength])/60.00 -- 奇数行: 返回中间的一个值
		ELSE AVG([TimeLength])/60.00 -- 偶数行: 返回中间两个值的平均值
    END AS [Median]
FROM [RowNums]
WHERE [RowNum] IN (([TotalRows] + 1) / 2, ([TotalRows] / 2) + 1);

-- 4. 计算飞翔场次(旧版：计算飞翔操作第二步)
SELECT COUNT([RoundId]) AS [TotalRound]
FROM [FX_TZ].[dbo].[DA_RoundProcedureInfo]
WHERE [Date] = '2024-08-29'
;

-- 新版：计算飞翔场次表
SELECT COUNT([RoundId]) AS [TotalRound]
FROM [FX_TZ].[dbo].[DA_RoundInfo]
WHERE [Date] = '2024-08-29'
;

-- 5. 计算熊熊射击游客及场次
SELECT COUNT([RoundId]) AS [TotalRound]
	, SUM(CustomerNum) AS [TotalCustomer]
FROM [XXLX_YT].[dbo].[DA_RoundInfo]
WHERE [Date] = '2024-08-29'
;
```

## 三、视图建立

### 1. 发车时间间隔视图

```sql
/*****************************************
 ** 创建人：TANGWY
 ** 输入：无
 ** 输出：[ZXDP_SZ].[dbo].[DA_RoundTimeInterval_SH_YT]
 ** 数据来源：[SH_YT].[dbo].[DA_RoundInfo]
 ** 作用：建立视图，计算鹰潭神画发车时间间隔。
********************************************/

/*鹰潭神画发车时间间隔视图建立*/
USE [ZXDP_SZ]
GO
CREATE VIEW [dbo].[DA_RoundTimeInterval_SH_YT] AS 
WITH [Interval] AS (
    SELECT [Date]
		, [StartTime]
		, DATEDIFF(SECOND, LAG([StartTime]) OVER (PARTITION BY Date ORDER BY [StartTime]), [StartTime]) AS [TimeInterval]	-- 发车时间间隔
    FROM [SH_YT].[dbo].[DA_RoundInfo]  
)
SELECT [Date]
	, [StartTime]
	, [TimeInterval]
FROM [Interval]
WHERE [TimeInterval] > 0 AND [TimeInterval] < 500
;
```

```sql
/*****************************************
 ** 创建人：TANGWY
 ** 输入：无
 ** 输出：[ZXDP_SZ].[dbo].[DA_RoundTime_NWBT]
 ** 数据来源：[MFCB_XZ].[dbo].[DA_RoundInfo], [NWBT_YT].[dbo].[DA_RoundInfo], [YZC_TZ].[dbo].[RoundInfo] 
 ** 作用：建立视图，统计三个公园的女娲补天运行时间相关数据
********************************************/

USE [ZXDP_SZ]
GO
CREATE VIEW [dbo].[DA_RoundTime_NWBT] AS
WITH [RoundTime] AS
(
	-- 徐州魔法城堡
	SELECT [Date]
		, [CarId]
		, [RoundId]
		, [StartTime]
		, [EndTime]
		, [TimeLength]
		, [TimeLengthStr]
		, DATEDIFF(SECOND, LAG(StartTime) OVER (PARTITION BY Date ORDER BY StartTime), StartTime) AS [TimeInterval] -- 发车时间间隔
		, '徐州' AS [Park]
    FROM [MFCB_XZ].[dbo].[DA_RoundInfo]
	UNION ALL
	-- 鹰潭女娲补天
	SELECT [Date]
		, [CarId]
		, [RoundId]
		, [StartTime]
		, [EndTime]
		, [TimeLength]
		, [TimeLengthStr]
		, DATEDIFF(SECOND, LAG(StartTime) OVER (PARTITION BY Date ORDER BY StartTime), StartTime) AS [TimeInterval] -- 发车时间间隔
		, '鹰潭' AS [Park]
    FROM [NWBT_YT].[dbo].[DA_RoundInfo] 
	UNION ALL
	-- 台州涌之城
	SELECT [Date]
		, [CarId]
		, [RoundId]
		, [StartTime]
		, [EndTime]
		, [TimeLength]
		, [TimeLengthStr]
		, DATEDIFF(SECOND, LAG(StartTime) OVER (PARTITION BY Date ORDER BY StartTime), StartTime) AS [TimeInterval] -- 发车时间间隔
		, '台州' AS [Park]
    FROM [YZC_TZ].[dbo].[RoundInfo] 
)
SELECT [Date]
	, [CarId]
	, [RoundId]
	, [StartTime]
	, [EndTime]
	, [TimeLength]
	, [TimeLengthStr]
	, [TimeInterval]
	, [Park]
FROM [RoundTime]
```

### 2. 等待时长计算视图

```sql
/*****************************************
 ** 创建人：TANGWY
 ** 输入：无
 ** 输出：[ZXDP_SZ].[dbo].[DA_RoundWaitTime_SLSG_TZ]
 ** 数据来源：[SLSG_TZ].[dbo].[Round_Abstract]
 ** 作用：建立视图，计算台州森林时光等待时长及场次
********************************************/

USE [ZXDP_SZ]
GO
CREATE VIEW [dbo].[DA_RoundWaitTime_SLSG_TZ] AS 
SELECT [Date]
	, [RoundID]
	, [Starttime]
	, [Endtime]
	, CASE
		WHEN [RoundID] = 1
		THEN 0
		ELSE ABS(DATEDIFF(SECOND, LAG([Endtime]) OVER (ORDER BY [Date],[RoundID]), [Starttime]))
	  END AS [WaitTimeLength]
FROM [SLSG_TZ].[dbo].[Round_Abstract]
;
```

```sql
/*****************************************
 ** 创建人：TANGWY
 ** 输入：无
 ** 输出：[ZXDP_SZ].[dbo].[DA_RoundWaitTime_TDYJ_HA]
 ** 数据来源：[TDYJ_HA].[dbo].[Round_Information]
 ** 作用：建立视图，计算淮安铁道游击等待时长及场次
********************************************/

USE [ZXDP_SZ]
GO
CREATE VIEW [dbo].[DA_RoundWaitTime_TDYJ_HA] AS
SELECT [Date]
	, [Car]
	, [RoundID]
	, [StartTime]
	, [EndTime]
	, CASE
		WHEN [RoundID] = 1
		THEN 0
		ELSE DATEDIFF(SECOND, LAG([EndTime]) OVER (PARTITION BY [Car] ORDER BY [Date],[RoundID]), [StartTime])
	  END AS [WaitTimeLength]
FROM [TDYJ_HA].[dbo].[Round_Information]
;
```

### 3. 公园项目最新日期汇总视图

```sql
/*****************************************
 ** 创建人：TANGWY
 ** 输入：无
 ** 输出：[ZXDP_SZ].[dbo].[DA_ProjectLatestDate], 临时表即用即删：[NWBT_YT].[dbo].#TempLog;
 ** 数据来源：自贡、淮安、台州、徐州、鹰潭、济宁六大公园的以'logs'结尾命名的所有数据表
 ** 作用：建立视图，汇总六大公园所有项目的最新日期，返回数据库名和最新日期，用于统计在线公园和在线项目数量。
********************************************/

USE [ZXDP_SZ];
GO
DECLARE @dbName NVARCHAR(128);
DECLARE @sql NVARCHAR(MAX) = N'';
DECLARE @checkSQL NVARCHAR(MAX);
DECLARE @dynamicSQL NVARCHAR(MAX);

-- 构建全局临时表存储符合条件的表名
IF OBJECT_ID('[ZXDP_SZ].[dbo].#TempLog') IS NOT NULL
	DROP TABLE #TempLog;

CREATE TABLE [ZXDP_SZ].[dbo].#TempLog(
	DatabaseName NVARCHAR(128),
	TableName NVARCHAR(256)
);

-- 游标用于遍历所有符合条件的数据库
DECLARE db_cursor CURSOR FOR
SELECT name FROM sys.databases 
WHERE (name LIKE '%_ZG' OR name LIKE '%_HA' OR name LIKE '%_TZ' OR name LIKE '%_XZ' OR name LIKE '%_YT' OR name LIKE '%_JN')
	AND name NOT LIKE '%NDV%'
	AND name != 'MJN_JN'
	AND name != 'MYMJN'
	AND name != 'LYFY_ZK_JN'
	AND name != 'FTLY_XZ'
	AND name != 'DFSH_YT'
	AND name != 'SHJC_JN';

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @dbName;

-- 动态构建SQL语句
WHILE @@FETCH_STATUS = 0
BEGIN
	-- 构建查询当前数据库中所有表名包含以‘logs’结尾的表，将结果放入临时表中
	SET @dynamicSQL = N'INSERT INTO #TempLog (DatabaseName, TableName) 
		SELECT ''' + @dbName + ''' , ''[' + @dbName + '].dbo.'' + t.name
		FROM ' + QUOTENAME(@dbName) + N'.sys.tables t 
		WHERE t.name LIKE ''%logs''';

	-- 执行动态SQL，插入表名到临时表
	EXEC (@dynamicSQL);
	FETCH NEXT FROM db_cursor INTO @dbName;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;

-- 遍历临时表，生成查询
DECLARE @currentDb NVARCHAR(128), @currentTable NVARCHAR(256);
DECLARE log_cursor CURSOR FOR
SELECT DatabaseName, TableName FROM #TempLog;

OPEN log_cursor;
FETCH NEXT FROM log_cursor INTO @currentDb, @currentTable;

WHILE @@FETCH_STATUS = 0
BEGIN
	IF LEN(@sql)>0
		SET @sql = @sql + N' UNION ALL ';
	SET @sql = @sql + N'SELECT TOP 1 ''' + @currentDb + N''' AS DatabaseName, MAX(Date) AS Date FROM ' + @currentTable;

	FETCH NEXT FROM log_cursor INTO @currentDb, @currentTable;
END

CLOSE log_cursor;
DEALLOCATE log_cursor;

-- 删除全局临时表
DROP TABLE [ZXDP_SZ].[dbo].#TempLog;

-- 聚合相同的数据库名并获取最新日期
SET @sql = N'SELECT DatabaseName, MAX(Date) AS Date From (' + @sql + N') AS Alllogs GROUP BY DatabaseName';

-- 删除已有视图
IF OBJECT_ID('dbo.DA_ProjectLatestDate','V') is not null
	DROP VIEW dbo.DA_ProjectLatestDate

-- 创建视图
IF LEN(@sql) >0
BEGIN
	SET @sql = 'CREATE VIEW [dbo].[DA_ProjectLatestDate] AS ' + @sql;
	PRINT @sql;
	EXEC sp_executesql @sql;
END


SELECT * FROM [ZXDP_SZ].[dbo].[DA_ProjectLatestDate];
```

