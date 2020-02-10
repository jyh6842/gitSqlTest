-- 직급 테이블 만들기
--DROP TABLE tb_grade;
--DROP TABLE tb_dept;
--DROP TABLE tb_job;
--DROP TABLE TB_EMP;
--DROP TABLE tb_cs_cd;
--DROP TABLE tb_counsel;


CREATE TABLE tb_grade(
    g_cd VARCHAR2(20) NOT NULL,
    g_nm VARCHAR2(50) NOT NULL,
    ord NUMBER,
    CONSTRAINT PK_cou_position PRIMARY KEY(g_cd)
);


CREATE TABLE tb_dept(
    d_cd VARCHAR2(20) NOT NULL,
    d_nm VARCHAR2(50) NOT NULL,
    p_d_cd VARCHAR2(20),
    
    CONSTRAINT PK_cou_dept PRIMARY KEY(d_cd),
    CONSTRAINT FK_cou_dept FOREIGN KEY(p_d_cd) REFERENCES tb_dept (d_cd)
);

CREATE TABLE tb_job(
    j_cd VARCHAR2(20) NOT NULL,
    j_nm VARCHAR2(50) NOT NULL,
    ord NUMBER,
    
    CONSTRAINT PK_tb_job PRIMARY KEY(j_cd)
);

CREATE TABLE tb_emp(
    e_no NUMBER NOT NULL,
    e_nm VARCHAR2(50) NOT NULL,  
    g_cd VARCHAR2(20) NOT NULL,
    j_cd VARCHAR2(20) NOT NULL,
    d_cd VARCHAR2(20) NOT NULL,
    
    CONSTRAINT PK_tb_emp PRIMARY KEY(e_no),
    CONSTRAINT FK_tb_emp_tb_grade FOREIGN KEY(g_cd) REFERENCES tb_grade (g_cd),
    CONSTRAINT FK_tb_emp_tb_dept FOREIGN KEY(j_cd) REFERENCES tb_job (j_cd),
    CONSTRAINT FK_tb_emp_tb_job FOREIGN KEY(d_cd) REFERENCES tb_dept (d_cd)
);

CREATE TABLE tb_cs_cd(
    cs_cd VARCHAR2(20) NOT NULL,
    cs_nm VARCHAR2(50) NOT NULL,
    p_cs_cd VARCHAR2(20),
    
    CONSTRAINT PK_tb_cs_cd PRIMARY KEY(cs_cd),
    CONSTRAINT FK_tb_cs FOREIGN KEY(p_cs_cd) REFERENCES tb_cs_cd (cs_cd)
);

CREATE TABLE tb_counsel(
    cs_id VARCHAR2(20) NOT NULL,
    cs_reg_dt DATE NOT NULL,
    cs_count VARCHAR2(4000) NOT NULL,
    e_no NUMBER NOT NULL,
    cs_cd1 VARCHAR2(20) NOT NULL,
    cs_cd2 VARCHAR2(20),
    cs_cd3 VARCHAR2(20),
    
    CONSTRAINT PK_tb_counsel PRIMARY KEY (cs_id),
    CONSTRAINT FK_tb_counsel_tb_emp FOREIGN KEY(e_no) REFERENCES tb_emp(e_no),
    CONSTRAINT FK_tb_counsel_tb_cs_cd1 FOREIGN KEY(cs_cd1) REFERENCES tb_cs_cd(cs_cd),
    CONSTRAINT FK_tb_counsel_tb_cs_cd2 FOREIGN KEY(cs_cd2) REFERENCES tb_cs_cd(cs_cd),
    CONSTRAINT FK_tb_counsel_tb_cs_cd3 FOREIGN KEY(cs_cd3) REFERENCES tb_cs_cd(cs_cd)
);