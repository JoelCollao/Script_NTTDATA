 import time
import datetime
import pyodbc
import pandas as pd
import logging
# import azure.functions as func
from azure.storage.blob import ContainerClient
from configparser import ConfigParser



# def main(mytimer: func.TimerRequest) -> None:
def main() -> None:
    print("INI:" + datetime.datetime.now().strftime("%m/%d/%Y, %H:%M:%S"))
    # Inicializacion del Parser
    config_parser = ConfigParser()
    config_parser.read(r'./config.ini')
    
    # Carga del driver, credenciales de la base de datos y del blob storage
    DRIVER = config_parser.get('sec-database', "database_driver")
    SERVER_NAME = config_parser.get('sec-database', 'database_servername')
    USER_NAME = config_parser.get('sec-database', 'database_username')
    DATABASE_NAME = config_parser.get('sec-database', 'database_name')
    PASSWORD = config_parser.get('sec-database', 'database_password')
    BLOB_CONNECTION_STRING = config_parser.get('sec-database', 'blob_connection')   
    
    COMPANY =  config_parser.get('sec-data', 'company_name')

    logging.info('Configuración cargada')

    # Conformacion del string de conexion
    CONNECTION_STRING = "DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}".\
        format(
        driver = DRIVER,
        server = SERVER_NAME,
        database = DATABASE_NAME,
        username = USER_NAME,
        password = PASSWORD
    )

    # Creacion de la conexion hacia la base de datos
    try:
        cnxn = pyodbc.connect(CONNECTION_STRING)
        cnxn2 = pyodbc.connect(CONNECTION_STRING)
    except pyodbc.OperationalError:
        time.sleep(2)
        cnxn = pyodbc.connect(CONNECTION_STRING)

    logging.info(msg='Conexion exitosa a la base de datos')    

    # print( cnxn.getinfo(pyodbc.SQL_MAX_CONCURRENT_ACTIVITIES))
    
    cursor = cnxn.cursor() # Creacion del objeto cursor

    # Sacar todos los bornes con LINE_ID
    query = '''
    SELECT B.LINE_ID, B.VNO_CODE, B.ID_DIVISOR, B.CODIGO, P.CODIGO_SITIO, D.CODIGO AS CODIGO_DIV
    FROM Red.BORNE B
    LEFT JOIN Red.PUERTO P ON P.ID_EQUIPO = B.ID_DIVISOR AND P.ID_TIPO_PUERTO=0 AND P.ID_TIPO_EQUIPO=2 --TIPO_PUERTO: ENTRADA TIPO_EQUIPO: DIVISOR_N2
    LEFT JOIN Red.DIVISOR D ON D.ID_DIVISOR = B.ID_DIVISOR
	LEFT JOIN Red.TERMINAL T ON T.ID_TERMINAL = D.ID_TERMINAL
	LEFT JOIN Red.PROYECTO PY ON PY.ID_PROYECTO = T.ID_PROYECTO
    WHERE LINE_ID IS NOT NULL AND LINE_ID <> ''
    '''

    # Sacar todos los bornes con LINE_ID
    queryGrafo = '''
    SELECT    Trace,
            (SELECT CODIGO FROM Red.DIVISOR WHERE ID_DIVISOR=SUBSTRING(REPLACE(Q.DIVISOR_N1,'&&',''),0,CHARINDEX('|', Q.DIVISOR_N1))) AS DIVISOR_N1,
            P.NOMBRE_COMPLETO AS CodigoPuertoODF,
            C.CODIGO  AS CODIGO_CABLE_ODF
    FROM     (
                SELECT Puerto1.ID_EQUIPO AS PuertoCTO,
                    STRING_AGG(CONCAT(Puerto2.ID_EQUIPO,'|',Puerto2.ID_TIPO_EQUIPO,'|',fi.ID_TRAMO_CABLE,'|',fi.SENAL,'|',fi.CUENTA), '&&') WITHIN GROUP (GRAPH PATH) AS Trace,
                    STRING_AGG(CASE WHEN Puerto2.ID_TIPO_EQUIPO=1 THEN CONCAT(Puerto2.ID_EQUIPO,'|') ELSE '' END, '') WITHIN GROUP (GRAPH PATH) AS DIVISOR_N1,
                    LAST_VALUE(Puerto2.ID_TIPO_EQUIPO) WITHIN GROUP (GRAPH PATH) AS LastNode,
                    LAST_VALUE(Puerto2.ID_EQUIPO) WITHIN GROUP (GRAPH PATH) AS LastNodeID,
                    LAST_VALUE(fi.ID_TRAMO_CABLE) WITHIN GROUP (GRAPH PATH) AS LastCableID
                FROM (SELECT * FROM  Red.PUERTO WHERE ID_EQUIPO = {ID_DIVISOR} AND ID_TIPO_PUERTO = 0 AND ID_TIPO_EQUIPO = 2 ) AS Puerto1, --ID_DIVISOR AND ENTRADA AND TIPO_CTO
                    (SELECT * FROM  Red.FIBRA WHERE  CODIGO_SITIO='{CODIGO_SITIO}') FOR PATH AS fi, --CODIGO_SITIO
                    Red.PUERTO FOR PATH AS Puerto2
                WHERE MATCH(SHORTEST_PATH(Puerto1(-(fi)->Puerto2)+))
    ) AS Q --CTO
    LEFT JOIN Red.PUERTO_ODF P ON Q.LastNodeID = P.ID_PUERTO_ODF
    LEFT JOIN Red.TRAMO_DE_CABLE C ON Q.LastCableID = C.ID_TRAMO_CABLE
    WHERE Q.LastNode = 0 --PUERTO_ODF
    '''
    queryLongitud='''
    SELECT SUM(L.LONGITUD) AS LONGITUD_TOTAL FROM (
        SELECT  
            CASE WHEN T.LONGITUD_REAL IS NOT NULL AND T.LONGITUD_REAL>0 THEN T.LONGITUD_REAL 
                WHEN T.LONGITUD_ESTIMADA IS NOT NULL AND T.LONGITUD_ESTIMADA >0 THEN T.LONGITUD_ESTIMADA 
                ELSE T.Shape.STLength() 
            END + ISNULL(S.LONGITUD,0) AS LONGITUD
        FROM Red.TRAMO_DE_CABLE T
        LEFT JOIN Red.SOBRA_DE_CABLE S ON T.ID_TRAMO_CABLE=S.ID_TRAMO_CABLE
        WHERE T.ID_TRAMO_CABLE IN ({ID_TRAMOS})
    ) AS L
    '''


    # columns = [column[0] for column in cursor.description]
    columns =['ACTION','LINE_ID','ACCESS_ID','FIBER_SEGMENT_1_NAME','FIBER_SEGMENT_1_LENGTH','SPLITTER_1_NAME','SPLITTER_1_RATIO','FIBER_SEGMENT_2_NAME','FIBER_SEGMENT_2_LENGTH','SPLITTER_2_NAME','SPLITTER_2_RATIO','PositionenCTO','FIBER_SEGMENT_3_LENGTH','CONNECTOR_COUNT','SPLICE_COUNT']
    
    logging.info(msg='Query ejecutado:' + query)
    
    records =[] 
    i=0
    cursor = cnxn.cursor() # Creacion del objeto cursor
    cursor.execute(query)
    
    for row in cursor: # Ejecucion de query y recoleccion de registros
        # time.sleep(3) # Sleep for 3 seconds
        print('{}: {}'.format(i, str(row)))
        i=i+1
        data={}
        data[columns[0]]='RECON'            # ACTION 
        data[columns[1]]=row.LINE_ID      # LINE_ID
        data[columns[2]]=row.VNO_CODE       # ACCESS_ID 
        # data[columns[3]]=None               # FIBER_SEGMENT_1_NAME 
        data[columns[4]]=0                  # FIBER_SEGMENT_1_LENGTH 
        # data[columns[5]]=None               # SPLITTER_1_NAME 
        data[columns[6]]=8                  # SPLITTER_1_RATIO 
        # data[columns[7]]=None               # FIBER_SEGMENT_2_NAME
        # data[columns[8]]=None               # FIBER_SEGMENT_2_LENGTH
        data[columns[9]]=row.CODIGO_DIV    # SPLITTER_2_NAME 
        data[columns[10]]=8                 # SPLITTER_2_RATIO 
        data[columns[11]]=row.CODIGO        # PositionenCTO 
        data[columns[12]]=0                 # FIBER_SEGMENT_3_LENGTH 
        data[columns[13]]=10                # CONNECTOR_COUNT 
        data[columns[14]]=4                 # SPLICE_COUNT 
        
        cnxn2 = pyodbc.connect(CONNECTION_STRING)
        cursorGrafo = cnxn2.cursor() # Creacion del objeto cursor
        rowGrafo = cursorGrafo.execute(queryGrafo.format(ID_DIVISOR=row.ID_DIVISOR, CODIGO_SITIO=row.CODIGO_SITIO)) # Ejecucion de query y recoleccion de registros
        data2 = rowGrafo.fetchone()
        if data2 is not None:
            data[columns[3]]=data2.CODIGO_CABLE_ODF
            data[columns[5]]=data2.DIVISOR_N1
            

            tramosCableAntesDivicau=[]
            vistoDIVICAU=False
            for traza in data2.Trace.split("&&"): #Cada traza tiene ID_EQUIPO, ID_TIPO_EQUIPO, ID_TRAMO_CABLE, SENAL, CUENTA
                items = traza.split("|")
                if not vistoDIVICAU and items[2]!='0':
                    tramosCableAntesDivicau.append(items[2])
                if items[1]=='1' and items[3] !='' and items[4] !='': #ES DIVICAU y tiene datos de SENAL y CUENTA
                    data[columns[7]]=items[3]+'_'+ items[4]
                    vistoDIVICAU=True

            if(len(tramosCableAntesDivicau)>0):
                rowLongitud = cursorGrafo.execute(queryLongitud.format(ID_TRAMOS=','.join(tramosCableAntesDivicau))) # Ejecucion de query y recoleccion de registros
                data2 = rowLongitud.fetchone()
                data[columns[8]]=data2.LONGITUD_TOTAL
            else:
                data[columns[8]]=0
        cursorGrafo.close()
        cnxn2.close()

        print(str(data))
        records.append(data)

    cursor.close()
    cnxn.close()

    if len(records)>0: 
        # Insercion de datos en pandas data frame    
        df = pd.DataFrame.from_records(
            data=records,
            columns=columns
        )   

        df = df.set_index(columns[0])
        output = df.to_csv( sep=',', encoding='utf-8')

        # Conexion hacia container de FileManager
        container_client = ContainerClient.from_connection_string(
            conn_str = BLOB_CONNECTION_STRING,
            container_name = 'output/ODN_OSP'
        )

        # Nombre de archivo dinámico
        filename = "OSP_ODN_{comp}_{ts}.csv".format(ts=datetime.datetime.today().strftime('%Y%m%d'),comp=COMPANY)

        print("Generado reporte ODN: "+filename)
        print("FIN:" + datetime.datetime.now().strftime("%m/%d/%Y, %H:%M:%S"))
        # Guardado de reporte en container de FileManager
        container_client.upload_blob(
            name = filename,
            data = output
        )
main()