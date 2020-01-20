create table Dia_chi(
	idDia_chi integer primary key,
    huyen nvarchar(20),
    tinh nvarchar(20)
);

create table Thanh_vien(
	idThanh_vien integer primary key,
    ho nvarchar(20) not null,
    ten nvarchar(20) not null,
	gioi_tinh nvarchar(10),
    ngay_sinh date,
    idDia_chi integer,
    email nvarchar(45) default "N/A",
    sdt varchar(20) default "N/A",
    cpa decimal(3,2),
    vien nvarchar(30),
    so_thich nvarchar(45),
	foreign key (idDia_chi) references Dia_chi(idDia_chi)
);

create table Mang(
	idMang integer primary key,
    ten_mang nvarchar(20),
    idMang_truong integer,
    foreign key (idMang_truong) references Thanh_vien(idThanh_vien)
);

create table Thanh_vien_Mang(
	idThanh_vien integer,
    idMang integer,
    chuyen_mon nvarchar(20),
    primary key (idThanh_vien, idMang),
    foreign key (idThanh_vien) references Thanh_vien(idThanh_vien),
    foreign key (idMang) references Mang(idMang)
);

create table Hoat_dong(
	idHoat_dong integer primary key,
    ten_hoat_dong nvarchar(45),
    dia_diem nvarchar(45),
    ngay date,
    idPhu_trach integer,
    foreign key (idPhu_trach) references Thanh_vien(idThanh_vien)
);

create table Thanh_vien_Hoat_dong(
	idThanh_vien integer,
    idHoat_dong integer,
    y_thuc nvarchar(20),
    primary key (idThanh_vien, idHoat_dong),
    foreign key (idThanh_vien) references Thanh_vien(idThanh_vien),
    foreign key (idHoat_dong) references Hoat_dong(idHoat_dong)
);
