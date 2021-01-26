"""
Methods to access to Mapping object
"""

from flask import session
from sqlalchemy import or_

from geonature.utils.env import DB
from geonature.core.gn_permissions.tools import cruved_scope_for_user_in_module

from pypnusershub.db.models import User

from .models import TMappings, CorRoleMapping


class TMappingsRepository:
    """
    Helper class to fetch mapping with cruved
    """

    def __init__(self):
        pass

    def get_user_mapping(self, info_role):
        ors_filter = []
        q = DB.session.query(TMappings.id_mapping, TMappings.is_public).outerjoin(
            CorRoleMapping, CorRoleMapping.id_mapping == TMappings.id_mapping
        )

        if info_role.value_filter == "1" or (
                info_role.value_filter == "2" and info_role.id_organisme is None
            ):
                ors_filter.append(CorRoleMapping.id_role == info_role.id_role)
        elif info_role.value_filter == "2":
            #  get id_role of the organism of the user
            subq_orga = (
                DB.session.query(User.id_role)
                .filter(User.id_organisme == info_role.id_organisme)
                .subquery()
            )
            ors_filter.append(CorRoleMapping.id_role == info_role.id_role)
            ors_filter.append(CorRoleMapping.id_role.in_(subq_orga))

        if info_role.value_filter in ("1", "2"):
            ors_filter.append(TMappings.is_public == True)

            q = q.filter(or_(*ors_filter))
        return [(m.id_mapping, m.is_public) for m in q.distinct().all()]

    def user_is_allowed_to(self, level, id_mapping, user_mappings, action):
        if level == "0" or level not in ("1", "2", "3"):
            return False
        if level == "3":
            return True
        if level in ("1", "2"):
            if action == 'U':
                found_mapping = None
                for m in user_mappings:
                    if m[0] == id_mapping:
                        found_mapping = m 
                if found_mapping:
                    return found_mapping[1] == False
                else:
                    return False
            else:
                return id_mapping in list(map(lambda m: m[0], user_mappings))

    def get_mapping_cruved(self, user_cruved, id_mapping, user_mappings):
        return {
            action: self.user_is_allowed_to(level, id_mapping, user_mappings, action)
            for action, level in user_cruved.items()
        }

    def get_all(self, info_role, with_cruved=False, mapping_type=None):
        """
        Get all mappings
        """
        users_mapping = self.get_user_mapping(info_role)
        q = DB.session.query(TMappings).filter(TMappings.temporary == False)
        if mapping_type:
            q = q.filter(TMappings.mapping_type == mapping_type.upper())
        if info_role.value_filter in ("1", "2"):
            q = q.filter(TMappings.id_mapping.in_(list(map(lambda m: m[0], users_mapping))))
        data = q.all()
        if with_cruved:
            user_cruved = cruved_scope_for_user_in_module(
            id_role=info_role.id_role,
                module_code="IMPORT",
                object_code="MAPPING",
            )[0]
            print("USER MAPPINGS")
            print(user_cruved)
            mapping_as_dict = []
            for d in data:
                temp = d.as_dict()
                temp["cruved"] = self.get_mapping_cruved(
                    user_cruved, d.id_mapping, users_mapping
                )
                print(temp)
                mapping_as_dict.append(temp)
            return mapping_as_dict
        return [d.as_dict() for d in data]

    def get_one(self, id_mapping, info_role, with_cruved):
        users_mapping = self.get_user_mapping(info_role)
        mapping = DB.session.query(TMappings).get(id_mapping)
        if mapping:
            mapping_as_dict = mapping.as_dict()
            if with_cruved:
                user_cruved = cruved_scope_for_user_in_module(
                    id_role=info_role.id_role,
                    module_code="IMPORT",
                    object_code="MAPPING",
                )[0]
                mapping_as_dict["cruved"] = self.get_mapping_cruved(
                    user_cruved, id_mapping, users_mapping
                )
            return mapping_as_dict
        return None
