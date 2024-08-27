--Author: MaurosMJ

SELECT
    tablespace_name          "Tablespace",
    block_size               "Block_Size",
    initial_extent           "Initial_Extent",
    next_extent              "Next_Extent",
    min_extents              "Minimum_Extents",
    max_extents              "Maximum_Extents",
    pct_increase             "Percent_Increase",
    min_extlen               "Minimum_Extent_Length",
    status                   "Status",
    contents                 "Contents",
    logging                  "Logging",
    force_logging            "Force_Logging",
    extent_management        "Extent_Management",
    allocation_type          "Allocation_Type",
    plugged_in               "Plugged_In",
    segment_space_management "Segment_Space_Management",
    def_tab_compression      "Default_Tab_Compression",
    retention                "Retention",
    bigfile                  "Big File"
FROM
    sys.dba_tablespaces
WHERE
    ( :tablespace_name IS NULL
      OR instr(lower(tablespace_name),
               lower(:tablespace_name)) > 0 )
ORDER BY
    1;