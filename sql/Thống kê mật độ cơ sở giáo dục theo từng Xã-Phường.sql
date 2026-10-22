/* Thống kê mật độ cơ sở giáo dục theo từng Xã/Phường (Point in Polygon) */

SELECT
	xp.xa_phuong AS ten_xa_phuong,
	xp.quan_huyen AS ten_quan_huyen,
	COUNT(gd.fid) AS so_luong_co_so_giao_duc,
	-- Tính diện tích khu vực xấp xỉ theo mặt Ellipsoid (km2)
	ROUND((ST_Area(xp.geom::geography) / 1000000)::numeric, 2) AS dien_tich_km2,
	-- Tính mật độ cơ sở giáo dục (số trường / km2)
	ROUND((COUNT(gd.fid)::numeric / (ST_Area(xp.geom::geography) / 1000000)::numeric), 2) AS mat_do_co_so_giao_duc
FROM xaphuong xp
LEFT JOIN co_so_giao_duc gd
ON ST_Contains (xp.geom, gd.geom)
GROUP BY xp.xa_phuong, xp.quan_huyen, xp.geom
ORDER BY mat_do_co_so_giao_duc DESC;