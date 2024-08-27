--@Author: MaurosMJ

SELECT
    privilege             "Privilege",
    initcap(admin_option) "Admin_Option"
FROM
    user_sys_privs
ORDER BY
    privilege;