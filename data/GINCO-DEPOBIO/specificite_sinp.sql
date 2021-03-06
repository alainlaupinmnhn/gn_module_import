-- Spécificité pour les instances SINP

-- Masquer certains champs à mapper
UPDATE gn_imports.dict_fields
SET display = FALSE 
WHERE name_field IN (
    'id_nomenclature_sensitivity',
    'id_digitiser',
    'meta_v_taxref',
    'meta_create_date',
    'meta_update_date'
);

-- Renommer le mapping 'Synthèse GeoNature'
UPDATE gn_imports.t_mappings
SET mapping_label = 'Synthèse GINCO'
WHERE mapping_label = 'Synthèse GeoNature';

-- Rendre certains champs obligatoires à mapper
UPDATE gn_imports.dict_fields
SET mandatory = TRUE
WHERE name_field IN ('id_nomenclature_source_status', 'observers', 'id_nomenclature_observation_status');

-- Supprimer certains champs à mapper
DELETE FROM gn_imports.t_mappings_fields
WHERE target_field in (
    'id_nomenclature_sensitivity',
    'id_digitiser',
    'meta_v_taxref',
    'meta_create_date',
    'meta_update_date'
);


-- INSERT INTO gn_permissions.cor_role_action_filter_module_object
--     (
--     id_role,
--     id_action,
--     id_filter,
--     id_module,
--     id_object
--     )
-- VALUES
--     ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Grp_admin' AND groupe IS TRUE), 1, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), 1),
--     ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Grp_admin' AND groupe IS TRUE), 2, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), 1),
--     ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Grp_admin' AND groupe IS TRUE), 3, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), 1),
--     ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Grp_admin' AND groupe IS TRUE), 6, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), 1)
-- ;

-- Permissions groupe admin sur module import
INSERT INTO gn_permissions.cor_role_action_filter_module_object
    (
    id_role,
    id_action,
    id_filter,
    id_module,
    id_object
    )
VALUES
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Administrateur' AND groupe IS TRUE), 1, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), 1),
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Administrateur' AND groupe IS TRUE), 2, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), 1),
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Administrateur' AND groupe IS TRUE), 3, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), 1),
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Administrateur' AND groupe IS TRUE), 6, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), 1)
;

-- Groupe producteur - Module import désactivé
INSERT INTO gn_permissions.cor_role_action_filter_module_object
    (
    id_role,
    id_action,
    id_filter,
    id_module,
    id_object
    )
VALUES
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Producteur' AND groupe IS TRUE), 1, 1, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), 1),
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Producteur' AND groupe IS TRUE), 2, 1, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), 1),
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Producteur' AND groupe IS TRUE), 3, 1, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), 1),
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Producteur' AND groupe IS TRUE), 6, 1, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), 1)
;

-- Droits du Groupe Admin sur objet mapping
-- Vérifier si c'est toujours utile ?
INSERT INTO gn_permissions.cor_role_action_filter_module_object
    (
    id_role,
    id_action,
    id_filter,
    id_module,
    id_object
    )
VALUES
    -- Groupe Admin sur objet mapping
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Administrateur' AND groupe IS TRUE), 1, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), (SELECT id_object FROM gn_permissions.t_objects WHERE code_object = 'MAPPING')),
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Administrateur' AND groupe IS TRUE), 2, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), (SELECT id_object FROM gn_permissions.t_objects WHERE code_object = 'MAPPING')),
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Administrateur' AND groupe IS TRUE), 3, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), (SELECT id_object FROM gn_permissions.t_objects WHERE code_object = 'MAPPING')),
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Administrateur' AND groupe IS TRUE), 6, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), (SELECT id_object FROM gn_permissions.t_objects WHERE code_object = 'MAPPING'))
;


-- INSERT INTO gn_permissions.cor_role_action_filter_module_object
--     (
--     id_role,
--     id_action,
--     id_filter,
--     id_module,
--     id_object
--     )
-- VALUES
--     -- Groupe Admin sur objet mapping
--     ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Grp_admin' AND groupe IS TRUE), 1, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), (SELECT id_object FROM gn_permissions.t_objects WHERE code_object = 'MAPPING')),
--     ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Grp_admin' AND groupe IS TRUE), 2, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), (SELECT id_object FROM gn_permissions.t_objects WHERE code_object = 'MAPPING')),
--     ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Grp_admin' AND groupe IS TRUE), 3, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), (SELECT id_object FROM gn_permissions.t_objects WHERE code_object = 'MAPPING')),
--     ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Grp_admin' AND groupe IS TRUE), 6, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), (SELECT id_object FROM gn_permissions.t_objects WHERE code_object = 'MAPPING'))
-- ;

-- Droits du Groupe Producteur sur objet mapping
-- Vérifier si c'est toujours utile ?
INSERT INTO gn_permissions.cor_role_action_filter_module_object
    (
    id_role,
    id_action,
    id_filter,
    id_module,
    id_object
    )
VALUES
    -- Groupe producteur sur objet mapping
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Producteur' AND groupe IS TRUE), 1, 1, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), (SELECT id_object FROM gn_permissions.t_objects WHERE code_object = 'MAPPING')),
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Producteur' AND groupe IS TRUE), 2, 4, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), (SELECT id_object FROM gn_permissions.t_objects WHERE code_object = 'MAPPING')),
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Producteur' AND groupe IS TRUE), 3, 1, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), (SELECT id_object FROM gn_permissions.t_objects WHERE code_object = 'MAPPING')),
    ((SELECT id_role FROM utilisateurs.t_roles WHERE nom_role = 'Producteur' AND groupe IS TRUE), 6, 1, (SELECT id_module FROM gn_commons.t_modules WHERE module_code='IMPORT'), (SELECT id_object FROM gn_permissions.t_objects WHERE code_object = 'MAPPING'))
;
