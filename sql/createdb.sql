CREATE DATABASE dawa_local ENCODING 'UTF-8' LC_COLLATE 'da_DK.UTF-8' LC_CTYPE 'da_DK.UTF-8' TEMPLATE template0;
ALTER DATABASE dawa_local SET cursor_tuple_fraction = 0.001;
ALTER DATABASE dawa_local SET random_page_cost = 1.1;
ALTER DATABASE dawa_local SET effective_cache_size='7GB';
ALTER DATABASE dawa_local SET join_collapse_limit=20;
ALTER DATABASE Ddawa_local SET from_collapse_limit=20;

\c dawa_local;
CREATE EXTENSION fuzzystrmatch;
