Drop database if exists DBKinalCare_2018520;
create database DBKinalCare_2018520;

use DBKinalCare_2018520;

create table Pacientes(
	codigoPaciente int not null,
    nombresPaciente varchar(50) not null,
    apellidosPaciente varchar(50) not null,
    sexo char not null,
    fechaNacimiento date not null,
    direccionPaciente varchar(100) not null,
    telefonoPersonal varchar(8) not null,
    fechaPrimeraVisita date,
    primary key PK_codigoPaciente (codigoPaciente)
);

create table Especialidades(
	codigoEspecialidad  int not null auto_increment,
    descripcion varchar(100) not null,
    primary key PK_codigoEspecialidad (codigoEspecialidad)
);

create table Medicamentos(
	codigoMedicamento int not null auto_increment,
    nombreMedicamento varchar(100) not null,
    primary key PK_codigoMedicamento (codigoMedicamento)
);

create table Doctores(
	numeroColegiado int not null,
    nombresDoctor varchar(50) not null,
    apellidosDoctor varchar(50) not null,
    codigoEspecialidad int not null,
    primary key PK_numeroColegiado (numeroColegiado),
    constraint FK_Doctores_Especialidades foreign key (codigoEspecialidad)
		references Especialidades (codigoEspecialidad)
);

create table Recetas(
	codigoReceta int not null auto_increment,
    fechaReceta date not null,
    numeroColegiado int not null,
    primary key PK_codigoReceta (codigoReceta),
    constraint FK_Recetas_Doctores foreign key (numeroColegiado)
		references Doctores (numeroColegiado)
);

create table DetalleReceta(
	codigoDetalleReceta int not null auto_increment,
    dosis varchar(100) not null,
    codigoReceta int not null,
    codigoMedicamento int not null,
    primary key PK_codigoDetalleReceta (codigoDetalleReceta),
    constraint FK_DetalleReceta_Receta foreign key (codigoReceta)
		references Recetas(codigoReceta),
	constraint FK_DetalleReceta_Medicamentos foreign key (codigoMedicamento)
		references Medicamentos (codigoMedicamento)
);

create table Citas(
	codigoCita int not null auto_increment,
    fechaCita date not null,
    horaCita time not null,
    tratamiento varchar(150),
    descripCondActual varchar(255) not null,
    codigoPaciente int not null,
    numeroColegiado int not  null,
    primary key PK_codigoCita (codigoCita),
    constraint FK_Citas_Pacientes foreign key (codigoPaciente)
		references Pacientes (codigoPaciente),
	constraint FK_Citas_Doctores foreign key (numeroColegiado)
		references Doctores (numeroColegiado)
);
-- ----------------------------------------------------------------------------------------------------
-- ---------------------------------------- PROCEDIMIENTOS ALMACENADOS --------------------------------
-- ------------------------- PACIENTES 
-- --------------- Agragar Paciente 
Delimiter $$
	create procedure sp_AgregarPaciente(in codigoPaciente int,in nombresPaciente varchar(50),
		in apellidosPaciente varchar(50),in sexo char,in fechaNacimiento date,
        in direccionPaciente varchar(100),in telefonoPersonal varchar(8), in fechaPrimeraVisita date)
        Begin
			insert into Pacientes (codigoPaciente, nombresPaciente, apellidosPaciente, sexo,
				fechaNacimiento, direccionPaciente, telefonoPersonal, fechaPrimeraVisita)
                values (codigoPaciente, nombresPaciente, apellidosPaciente, upper(sexo),
				fechaNacimiento, direccionPaciente, telefonoPersonal, fechaPrimeraVisita);
        End$$
Delimiter ;

call sp_AgregarPaciente(1002,'Pedro Manuel','Armas Chang','m','1982-08-17','Zona 1 Mixco','12435365',now());
call sp_AgregarPaciente(1003,'Pedro Manuel','Armas Chang','m','1982-08-17','Zona 1 Mixco','12435365',now());

-- --------------- Listar Paciente
Delimiter $$
	create procedure  sp_ListarPacientes()	
	Begin 
		select 
			P.codigoPaciente,
            P.nombresPaciente,
            P.apellidosPaciente,
            P.sexo,
            P.fechaNacimiento,
            P.direccionPaciente,
            P.telefonoPersonal,
            P.fechaPrimeraVisita
        from Pacientes P;
    End$$
Delimiter ; 
call sp_ListarPacientes();

-- --------------- Buscar Paciente
Delimiter $$
	create procedure  sp_BuscarPaciente(in codPaciente int)
	Begin 
		select 
			P.codigoPaciente,
            P.nombresPaciente,
            P.apellidosPaciente,
            P.sexo,
            P.fechaNacimiento,
            P.direccionPaciente,
            P.telefonoPersonal,
            P.fechaPrimeraVisita
        from Pacientes P where codPaciente = P.codigoPaciente;
    End$$
Delimiter ; 
call sp_BuscarPaciente(1002);

-- --------------- Eliminar Paciente
Delimiter $$
	create procedure sp_EliminarPaciente(in codPaciente int)
    Begin
		delete from Pacientes
			where codigoPaciente = codPaciente;
	End$$
Delimiter ;
call sp_EliminarPaciente(1001);

call sp_ListarPacientes();

-- --------------- Editar Paciente
Delimiter $$
	create procedure sp_EditarPaciente (in codPaciente int,in nomPaciente varchar(50),
		in apePaciente varchar(50),in sx char,in fechaNac date,in dirPaciente varchar(100),
		in telPersonal varchar(8),in fechaPV date)
        Begin 
			update Pacientes P
				set
					P.nombresPaciente = nomPaciente,
                    P.apellidosPaciente =  apePaciente,
                    P.sexo = upper(sx),
					P.fechaNacimiento = fechaNac,
                    P.direccionPaciente = dirPaciente,
                    P.telefonoPersonal = telPersonal,
                    P.fechaPrimeraVisita = fechaPV
                    where codigoPaciente = codPaciente;
        End$$
Delimiter ;
call sp_EditarPaciente(1002,'Job Willka','Sis Rodriguez','m','2005-04-28','Zona 6 ','12435365',now());
