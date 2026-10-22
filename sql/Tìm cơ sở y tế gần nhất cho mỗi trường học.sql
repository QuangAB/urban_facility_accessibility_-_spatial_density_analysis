/* Tìm cơ sở y tế gần nhất cho mỗi trường học */

SELECT 
    gd.ten AS ten_truong_hoc,
    yt.ten AS co_so_y_te_gan_nhat,
    -- Tính khoảng cách chính xác theo mét (geography)
    ROUND(ST_Distance(gd.geom::geography, yt.geom::geography)::numeric, 2) AS khoang_cach_m
FROM co_so_giao_duc gd
CROSS JOIN LATERAL (
    SELECT yt.ten, yt.geom
    FROM co_so_y_te yt
    ORDER BY gd.geom <-> yt.geom -- Toán tử KNN Index tối ưu tốc độ tìm kiếm
    LIMIT 1
) yt
ORDER BY khoang_cach_m ASC;