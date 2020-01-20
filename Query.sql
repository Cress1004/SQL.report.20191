

-- 1.Lấy thông tin mảng trưởng và số thành viên có trong mảng đó
select 
	idMang_truong as  id,
	concat(Thanh_vien.ho,' ',Thanh_vien.ten) as 'Tên Mảng Trưởng',
    Mang.ten_mang as ' Tên mảng ',
    so_thanh_vien
from Mang inner join 
	(select 
		count(Thanh_vien.idThanh_vien) as so_thanh_vien,
        Thanh_vien_Mang.idMang
	from Thanh_vien inner join Thanh_vien_Mang
	on(Thanh_vien.idThanh_vien=Thanh_vien_Mang.idThanh_vien)
	group by Thanh_vien_Mang.idMang) as a
on(Mang.idMang=a.idMang)
inner join Thanh_vien
on(Thanh_vien.idThanh_vien=Mang.idMang_truong);




-- 2.Lấy ngẫu nhiên thông tin 15 sinh viên nam có sở thích đá bóng hoặc bóng rổ và quê ở một trong 3 tỉnh Hà Nam,Nam Đinh,Ninh Bình

select 
	idThanh_vien, ho, ten, tinh  
from Thanh_vien inner join Dia_chi
on(Thanh_vien.idDia_chi=Dia_chi.idDia_chi)
where 
	tinh in('Hà Nam','Nam Định','Ninh Bình')
	and gioi_tinh = 'Nam'
	and (so_thich like '%đá bóng%' or so_thich like "%bóng rổ%") 
order by rand() limit 15;




-- 3.Lấy thông tin sinh viên có tên kết thúc bằng "ng", thuộc viện CNTT&TT và có số hoạt động lớn hơn hoặc bằng 3


select 
	a.id as idThanh_vien,
    concat_ws(' ',a.ho,a.ten) as 'Họ và tên',
    a.vien as Vien,
    a.so_hoat_dong as 'Số hoạt động'
from 
	(select 
		ho,ten,
		Thanh_vien_Hoat_dong.idThanh_vien as id,
        count(idHoat_dong) as so_hoat_dong,
        vien
	from Thanh_vien_Hoat_dong
	inner join Thanh_vien
	on(Thanh_vien_Hoat_dong.idThanh_vien=Thanh_vien.idThanh_vien)
	group by Thanh_vien_Hoat_dong.idThanh_vien) as a
where 
	Vien = 'CNTT&TT'
	and a.ten regexp 'ng$'
	and a.so_hoat_dong >=3;


-- 4.Lấy ra thông tin của hoạt động có nhiều thành viên nhất

SELECT 
    Hoat_dong.idHoat_dong,
Hoat_dong.ten_hoat_dong,
        COUNT(Thanh_vien_Hoat_dong.idThanh_vien) AS Tong_thanh_vien
FROM Hoat_dong INNER JOIN Thanh_vien_Hoat_dong
ON(Hoat_dong.idHoat_dong = Thanh_vien_Hoat_dong.idHoat_dong)
GROUP BY Thanh_vien_Hoat_dong.idHoat_dong
HAVING Tong_thanh_vien >= all (SELECT  COUNT(Thanh_vien_Hoat_dong.idThanh_vien) AS Tong_thanh_vien 
FROM Hoat_dong 
INNER JOIN Thanh_vien_Hoat_dong 
ON(Hoat_dong.idHoat_dong = Thanh_vien_Hoat_dong.idHoat_dong)
GROUP BY Thanh_vien_Hoat_dong.idHoat_dong); 


-- 5.Tính số sinh viên nam,nữ của từng mảng

select 
	Mang.idMang,
    Mang.ten_mang,
	count(case when Thanh_vien.gioi_tinh = 'Nam' then 1 end) as Nam,
	count(case when Thanh_vien.gioi_tinh = 'Nữ' then 1 end) as Nu
from Mang inner join Thanh_vien_Mang
on (Mang.idMang = Thanh_vien_Mang.idMang)
inner join Thanh_vien
on (Thanh_vien_Mang.idThanh_vien=Thanh_vien.idThanh_vien)
group by idMang;




-- 6.Lấy thông tin sinh viên là nam thích nấu ăn và có chuyên môn chụp ảnh

select 
	Thanh_vien.idThanh_vien,
    Thanh_vien.ho,
    Thanh_vien.ten,
    chuyen_mon,so_thich
from Thanh_vien inner join Thanh_vien_Mang
on Thanh_vien.idThanh_vien=Thanh_vien_Mang.idThanh_vien 
where 
	gioi_tinh = 'Nam'
	and Thanh_vien.so_thich like '%nấu ăn%'
	and chuyen_mon = 'chụp ảnh';
	




-- 7.Thông tin sinh viên tham gia hoạt động Chủ Nhật đỏ 
select 
	Thanh_vien.idThanh_vien,ho,ten 
from Thanh_vien inner join Thanh_vien_Hoat_dong
on(Thanh_vien.idThanh_vien= Thanh_vien_Hoat_dong.idThanh_vien)
inner join Hoat_dong
on Thanh_vien_Hoat_dong.idHoat_dong=Hoat_dong.idHoat_dong
where ten_hoat_dong='Chủ Nhật đỏ';





-- 8.Lấy thông tin 10 sinh viên có số hoạt động phụ trách là nhiều nhất 

select 
	Thanh_vien.idThanh_vien,
    Thanh_vien.ho,Thanh_vien.ten, 
    so_hoat_dong_phu_trach
from Thanh_vien
inner join 
	(select 
		count(idHoat_dong) as so_hoat_dong_phu_trach,
        idPhu_trach
	from Hoat_dong group by idPhu_trach
	order by so_hoat_dong_phu_trach desc limit 10) as Hoat_dong_Phu_trach
on Thanh_vien.idThanh_vien = Hoat_dong_Phu_trach.idPhu_trach;





-- 9. Đưa ra thông tin 5 hoạt động mà có số sinh viên nữ tham gia nhiều nhất 
select * from Hoat_dong
inner join
	(select 
		idHoat_dong,
		count(case when Thanh_vien.gioi_tinh='Nữ' then 1 end) as Nu 
	from Thanh_vien_Hoat_dong inner join Thanh_vien
	on Thanh_vien_Hoat_dong.idThanh_vien= Thanh_vien.idThanh_vien
	group by idHoat_dong
	order by Nu desc limit 5) as a
on Hoat_dong.idHoat_dong= a.idHoat_dong;



      
-- 10. Đưa ra thông tin sinh viên có cpa >=3.0 thuộc mảng Truyền thông và số hoạt động tham gia của từng thành viên

select 
	tong_hop.idThanh_vien,
    tong_hop.ho,
    tong_hop.ten,
    tong_hop.cpa,
    so_hoat_dong
from
	(select 
		ho,
        ten,
        Thanh_vien_Hoat_dong.idThanh_vien,
        count(idHoat_dong) as so_hoat_dong,
        cpa
	from Thanh_vien_Hoat_dong left join Thanh_vien
	on(Thanh_vien_Hoat_dong.idThanh_vien=Thanh_vien.idThanh_vien)
	group by Thanh_vien_Hoat_dong.idThanh_vien) as tong_hop
inner join Thanh_vien_Mang
on(tong_hop.idThanh_vien=Thanh_vien_Mang.idThanh_vien)
where 
	Thanh_vien_Mang.idMang in (select idMang from Mang where ten_mang='Truyền thông')
	and tong_hop.cpa>=3.0;




-- Câu 11: Tính điểm hoạt động của thành viên trong đội theo thứ tự điểm từ cao xuống thấp
select 
		Thanh_vien.idThanh_vien, 
        concat(ho," ",ten) as "Họ và tên",
		sum(case
				when y_thuc = "Tốt" then 2 + 5 
				when y_thuc = "Khá" then 1 + 5 
				else 0 + 5 
		end) as "Diem_so" 
from Thanh_vien_Hoat_dong inner join Thanh_vien 
on Thanh_vien.idThanh_vien = Thanh_vien_Hoat_dong.idThanh_vien 
group by Thanh_vien_Hoat_dong.idThanh_vien 
order by Diem_so desc;


-- Câu 12: Lấy ngẫu nhiên 5 thành viên có chuyên môn là "Chụp ảnh" 
-- để phục vụ cho hoạt động

select 
	concat(ho," ",ten) as "Ho va Ten" 
from Thanh_vien inner join Thanh_vien_Mang 
on Thanh_vien.idThanh_vien = Thanh_vien_Mang.idThanh_vien 
where chuyen_mon = "chụp ảnh" 
order by rand() limit 5;





-- Câu 13: Chọn các ứng viên cho hoạt động là các bạn vừa có chuyên môn "phục vụ chung" vừa có chuyên môn "tuyên truyền"

select 
	Thanh_vien.idThanh_vien, 
    concat(ho," ",ten) as "Ho_va_Ten" 
from Thanh_vien inner join Thanh_vien_Mang 
on Thanh_vien.idThanh_vien = Thanh_vien_Mang.idThanh_vien 
where 
	chuyen_mon = "phục vụ chung" 
	and Thanh_vien.idThanh_vien in (select Thanh_vien.idThanh_vien from Thanh_vien 
	inner join Thanh_vien_Mang on Thanh_vien.idThanh_vien = Thanh_vien_Mang.idThanh_vien 
    where chuyen_mon = "tuyên truyền");  





-- Câu 14: Liệt kê các thành viên thuộc mảng "Hậu cần" 
-- Yêu cầu có cột STT, cột nhiệm vụ trong mảng, mảng trường phải ở vị trí bàn ghi đầu tiên
set @i = 0;
set @j = 1;
(select 
	i as "STT", 
    "Mảng trưởng" as "Nhiệm vụ",  
    concat(ho," ",ten) as "Ho_va_Ten" 
from 
	(select 
		@i := @i + 1 as i, 
        ho, ten 
	from Thanh_vien inner join Mang 
	on Thanh_vien.idThanh_vien = Mang.idMang_truong 
	where ten_mang = "Hậu cần") a
) 
union 
(select 
	j as "STT", 
    chuyen_mon as "Nhiệm vụ" ,
    concat(ho," ",ten) as "Ho_va_Ten" 
from 
	(select 
		@j := @j + 1 as j, 
        chuyen_mon, 
        ho, ten 
	from Thanh_vien inner join Thanh_vien_Mang 
    on Thanh_vien.idThanh_vien = Thanh_vien_Mang.idThanh_vien 
	inner join Mang on Thanh_vien_Mang.idMang = Mang.idMang 
    where ten_mang = "Hậu cần" 
    and Thanh_vien.idThanh_vien != idMang_truong) b
);




-- Câu 15: Tuyên dương những bạn có thành tích hoạt động cao nhất hoạt động trong mảng "Phong trào"

select 
		Thanh_vien.idThanh_vien, 
		concat(ho," ",ten) as "Họ_và_tên", 
		ten_mang,   
		sum(case 
			when y_thuc = "Tốt" then 2 + 5        
			when y_thuc = "Khá" then 1 + 5       
			else 0 + 5 
		end) as "Diem_so"  
from Thanh_vien_Hoat_dong inner join Thanh_vien 
on Thanh_vien_Hoat_dong.idThanh_vien = Thanh_vien.idThanh_vien  
inner join Thanh_vien_Mang on Thanh_vien.idThanh_vien = Thanh_vien_Mang.idThanh_vien  
inner join Mang on Thanh_vien_Mang.idMang = Mang.idMang 
where ten_mang = "Phong trào" group by Thanh_vien.idThanh_vien 
having Diem_so >= all(
	select 
		sum(case 
			when y_thuc = "Tốt" then 2 + 5        
			when y_thuc = "Khá" then 1 + 5       
			else 0 + 5 
		end) as "Diem_so"  
	from Thanh_vien_Hoat_dong inner join Thanh_vien 
	on Thanh_vien_Hoat_dong.idThanh_vien = Thanh_vien.idThanh_vien  
	inner join Thanh_vien_Mang on Thanh_vien.idThanh_vien = Thanh_vien_Mang.idThanh_vien  
	inner join Mang on Thanh_vien_Mang.idMang = Mang.idMang 
	where ten_mang = "Phong trào" group by Thanh_vien.idThanh_vien );



-- Câu 16: Tìm những bạn có nhiều sở thích nhất 

select 
	Thanh_vien.idThanh_vien,
    concat(ho," ",ten) as "Họ và tên", 
	round((length(so_thich) - length(replace(so_thich,",","")))/length(","))+1 as "Số_sở_thích"
from Thanh_vien having Số_sở_thích >= all 
(select 
	round((length(so_thich) - length(replace(so_thich,",","")))/length(","))+1 as "Số_sở_thích" 
from Thanh_vien); 




-- Câu 17: Trong top 10 thành viên tham gia nhiều mảng nhất, tìm ra 5 thành viên có điểm hoạt động thấp nhất


 select 
	idThanh_vien,          
	Họ_và_tên, 
	Số_mảng_tham_gia, 
	sum(case 
			when y_thuc = "Tốt" then 2 + 5         
			when y_thuc = "Khá" then 1 + 5       
			else 0 + 5 
	end) as "Diem_so"  
from 
	Thanh_vien_Hoat_dong inner join 
	(select 
		Thanh_vien.idThanh_vien as "id",
		concat(ho," ",ten) as "Họ_và_tên", 
		count(idMang) as "Số_mảng_tham_gia" 
	from Thanh_vien  inner join Thanh_vien_Mang 
	on Thanh_vien.idThanh_vien = Thanh_vien_Mang.idThanh_vien 
	group by Thanh_vien_Mang.idThanh_vien order by count(idMang) desc limit 10) top_10 
on Thanh_vien_Hoat_dong.idThanh_vien = top_10.id group by top_10.id  
order by Diem_so limit 5;




-- Câu 18: Truy vấn ngày đầu tham gia hoạt động và ngày gần nhất tham gia hoạt động của từng thành viên

select distinct 
	a.idThanh_vien, 
    concat(ho," ",ten) as "Họ_và_tên", 
	u1.ngay as "Ngày đầu tham gia", 
    u2.ngay as "Ngày tham gia gần đây nhất" 
from Thanh_vien a, 
	 Thanh_vien_Hoat_dong th1, 
     Thanh_vien_Hoat_dong th2, 
     Hoat_dong u1, 
     Hoat_dong u2 
where 
	th1.idThanh_vien = th2.idThanh_vien 
    and th1.idThanh_vien = a.idThanh_vien 
	and th1.idHoat_dong = u1.idHoat_dong 
    and th2.idHoat_dong = u2.idHoat_dong 
	and u1.ngay = 
		(select min(ngay) from Thanh_vien, Thanh_vien_Hoat_dong, Hoat_dong 
		where Thanh_vien.idThanh_vien = Thanh_vien_Hoat_dong.idThanh_vien 
		and Thanh_vien_Hoat_dong.idHoat_dong = Hoat_dong.idHoat_dong 
        and Thanh_vien.idThanh_vien = a.idThanh_vien)
	and u2.ngay = 
		(select max(ngay) from Thanh_vien, Thanh_vien_Hoat_dong, Hoat_dong 
		where Thanh_vien.idThanh_vien = Thanh_vien_Hoat_dong.idThanh_vien 
		and Thanh_vien_Hoat_dong.idHoat_dong = Hoat_dong.idHoat_dong 
        and Thanh_vien.idThanh_vien = a.idThanh_vien);




-- Câu 19: Tìm lịch sử hoạt động của 1 thành viên tên là "Nguyễn Quang Lộc"

select 
	ten_hoat_dong, 
    ngay, 
    dia_diem 
from Thanh_vien inner join Thanh_vien_Hoat_dong 
on Thanh_vien.idThanh_vien = Thanh_vien_Hoat_dong.idThanh_vien 
inner join Hoat_dong on Thanh_vien_Hoat_dong.idHoat_dong = Hoat_dong.idHoat_dong 
where concat(ho," ",ten) = "Nguyễn Quang Lộc";   

-- 20.Hoat dong dien ra nhieu nhat trong nam 2019
select 
	ten_hoat_dong, 
	count(idHoat_dong) as "Số_lần_tổ_chức_trong_năm_2019" 
from Hoat_dong 
where date_format(ngay,"%Y") = 2019 
group by ten_hoat_dong 
having Số_lần_tổ_chức_trong_năm_2019 >= all (select count(idHoat_dong) 
as "Số_lần_tổ_chức_trong_năm_2019" from Hoat_dong 
where date_format(ngay,"%Y") = 2019 group by ten_hoat_dong);


-- Câu 21: Chọn 10 thành viên từ bảng thành viên bắt đầu từ bản ghi thứ 20 (ứng dụng trong phân trang cho việc hiển thị csdl)
-- Sử dụng offset
select * from Thanh_vien limit 10 offset 19; 
-- Không sử dụng offset
select * from Thanh_vien where idThanh_vien >= 21 limit 10;




-- 22.Truy vấn những thành viên không hoạt động trong hai tháng 11 và tháng 12
select  
	idThanh_vien, 
    concat(ho, " ", ten) as Ho_va_ten 
from Thanh_vien
where idThanh_vien not in 
	(select 
		distinct Thanh_vien.idThanh_vien 
	from Thanh_vien_Hoat_dong join Thanh_vien 
    on Thanh_vien_Hoat_dong.idThanh_vien = Thanh_vien.idThanh_vien 
	join Hoat_dong on Thanh_vien_Hoat_dong.idHoat_dong = Hoat_dong.idHoat_dong
	where 
		ngay >= '2019-11-01' 
        and ngay <'2020-01-01');


-- Câu 23:  Đưa ra top 10 thành viên có điểm hoạt động cao nhất và có điểm CPA >=3.2 để nộp hồ sơ xét sinh viên 5 tốt

select 
	Thanh_vien.idThanh_vien, 
	concat(ho," ",ten) as "Họ và tên", 
	sum(case
			when y_thuc = "Tốt" then 2 + 5
			when y_thuc = "Khá" then 1 + 5
			else 0 + 5
	end) as "Diem_so",
    cpa 
from Thanh_vien_Hoat_dong inner join Thanh_vien 
on Thanh_vien_Hoat_dong.idThanh_vien = Thanh_vien.idThanh_vien  
where cpa >= 3.2 
group by Thanh_vien.idThanh_vien 
order by Diem_so desc limit 10;



-- 24. Thang co so hoat dong dien ra nhieu nhat trong năm 2019
select 
	date_format(ngay, "%M") as Thang, 
    count(idHoat_dong) as "Số_lần_tổ_chức_sự_kiện" 
from Hoat_dong 
where date_format(ngay, "%Y") = 2019 
group by Thang 
having Số_lần_tổ_chức_sự_kiện >= all (select count(idHoat_dong) as "Số_lần_tổ_chức_sự_kiện" 
from Hoat_dong where date_format(ngay, "%Y") = 2019 group by date_format(ngay, "%M"));




-- 25. Chọn những bạn có ngày sinh là tháng 1
select 
	idThanh_vien, 
    concat(ho, " ", ten), 
    ngay_sinh 
from Thanh_vien 
where date_format(ngay_sinh, "%m") = 1;




-- 26. Cập nhật email của các thành viên trong mảng truyền thông thành dạng @media.vit.com
update 
	(Thanh_vien_Mang join Thanh_vien 
    on Thanh_vien_Mang.idThanh_vien = Thanh_vien.idThanh_vien
	join Mang on Thanh_vien_Mang.idMang = Mang.idMang)
set email = concat(substring_index(email,"@",1),"@media.vit.com") 
where ten_mang = "truyền thông";


-- 27.Liệt kê các hoạt động trong tháng 10 và số lượng thành viên hoat động tốt, khá, kém

select 
	Hoat_dong.idHoat_dong,
    ten_hoat_dong, 
    ngay,
	count(case when y_thuc = "tốt" then 1 end) as Tốt,
	count(case when y_thuc = "khá" then 1 end) as Khá,
	count(case when y_thuc = "kém" then 1 end) as Kém
from Thanh_vien_Hoat_dong, Hoat_dong 
where 
	Thanh_vien_Hoat_dong.idHoat_dong = Hoat_dong.idHoat_dong 
	and date_format(ngay, "%m") =10
group by idHoat_dong;

-- 28. Liệt kê hoạt động và tổng các hoạt động trong tháng 4

(select 
	ngay as "Thời gian", 
    ten_hoat_dong as "Tên hoạt động" 
from Hoat_dong where date_format(ngay,"%m") = 4) 
union
(select "------------------------","------------------------------------")
union 
(select 
	"Tổng số", 
	count(ten_hoat_dong) 
from Hoat_dong where date_format(ngay,"%m") = 4);  


-- 29. Liệt kê những thành viên tham gia mảng "Truyền thông" mà không tham gia mảng "Hậu cần" 

select 
	Thanh_vien.idThanh_vien, 
    concat(ho," ",ten) as "Họ_và_tên" 
from Thanh_vien inner join Thanh_vien_Mang 
on Thanh_vien.idThanh_vien = Thanh_vien_Mang.idThanh_vien 
inner join Mang on Thanh_vien_Mang.idMang = Mang.idMang 
where 
	ten_mang = "Truyền thông" 
	and Thanh_vien.idThanh_vien not in (select Thanh_vien.idThanh_vien 
from Thanh_vien inner join Thanh_vien_Mang 
on Thanh_vien.idThanh_vien = Thanh_vien_Mang.idThanh_vien 
inner join Mang on Thanh_vien_Mang.idMang = Mang.idMang 
where ten_mang = "Hậu cần");

-- 30. Tạo procedure liệt kê  tất cả các thành viên có sở thích là "so_thich_dk" và quê ở "tinh_dk"

DROP PROCEDURE select_so_thich_tinh;
DELIMITER $$
CREATE PROCEDURE select_so_thich_tinh( 
	IN so_thich_dk nvarchar(10),  
    IN tinh_dk nvarchar(10) 
) 
BEGIN     
	set @x = 0;
	select x as "STT", idThanh_vien, Họ_và_tên from 
    (select @x := @x + 1 as x, idThanh_vien, concat(ho," ",ten) as "Họ_và_tên" 
    from Thanh_vien inner join Dia_chi on Thanh_vien.idDia_chi = Dia_chi.idDia_chi
    where so_thich like concat("%",so_thich_dk,"%") and tinh = tinh_dk) a; 
END$$ 
DELIMITER ;

call select_so_thich_tinh("nhảy","Hà Nội");


