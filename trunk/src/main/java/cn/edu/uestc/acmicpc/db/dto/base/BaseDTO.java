/*
 *
 *  * cdoj, UESTC ACMICPC Online Judge
 *  * Copyright (c) 2013 fish <@link lyhypacm@gmail.com>,
 *  * 	mzry1992 <@link muziriyun@gmail.com>
 *  *
 *  * This program is free software; you can redistribute it and/or
 *  * modify it under the terms of the GNU General Public License
 *  * as published by the Free Software Foundation; either version 2
 *  * of the License, or (at your option) any later version.
 *  *
 *  * This program is distributed in the hope that it will be useful,
 *  * but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  * GNU General Public License for more details.
 *  *
 *  * You should have received a copy of the GNU General Public License
 *  * along with this program; if not, write to the Free Software
 *  * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 */

package cn.edu.uestc.acmicpc.db.dto.base;

import cn.edu.uestc.acmicpc.util.StringUtil;
import cn.edu.uestc.acmicpc.util.annotation.Ignored;
import cn.edu.uestc.acmicpc.util.exception.AppException;

import java.io.Serializable;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

/**
 * Base DTO entity, use reflection to update entity.
 * <p/>
 * <strong>USAGE</strong>:
 * extends the class from this class, and set the getter with {@code Ignored} if
 * you do not set value in get/update method.
 * <p/>
 * If set the field to {@code null}, this field will not be updated in
 * {@code updateEntity} method.
 *
 * @author <a href="mailto:lyhypacm@gmail.com">fish</a>
 * @version 4
 */
public abstract class BaseDTO<Entity extends Serializable> {
    protected abstract Class<Entity> getReferenceClass();

    /**
     * Get entity by DTO fields.
     *
     * @return new entity instance
     * @throws AppException
     */
    public Entity getEntity() throws AppException {
        try {
            Constructor<Entity> constructor = getReferenceClass().getConstructor();
            Entity entity = constructor.newInstance();
            Method[] methods = getClass().getMethods();
            for (Method method : methods) {
                if (method.getName().startsWith("get")) {
                    String name = StringUtil.getGetterOrSetter(StringUtil.MethodType.SETTER,
                            method.getName().substring(3));
                    Ignored ignored1 = method.getAnnotation(Ignored.class);
                    if (ignored1 == null || !ignored1.value()) {
                        try {
                            Method setter = entity.getClass().getMethod(name, method.getReturnType());
                            Method getter = entity.getClass().getMethod(method.getName());
                            if (method.invoke(this) != null)
                                setter.invoke(entity, method.invoke(this));
                            if (getter.invoke(entity) == null) {
                                // If entity's field is null, we must initialize the value of this field
                                if (getter.getReturnType().equals(String.class)) {
                                    setter.invoke(entity, "");
                                } else {
                                    setter.invoke(entity, 0);
                                }
                            }
                        } catch (NoSuchMethodException | InvocationTargetException |
                                IllegalAccessException ignored) {
                        }
                    }
                }
            }
            return entity;
        } catch (NoSuchMethodException | InvocationTargetException |
                InstantiationException | IllegalAccessException e) {
            e.printStackTrace();
            throw new AppException("Invoke getEntity method error.");
        }
    }

    /**
     * Update entity by DTO fields.
     *
     * @param entity entity to be updated
     */
    public void updateEntity(Entity entity) {
        Method[] methods = getClass().getMethods();
        for (Method method : methods) {
            if (method.getName().startsWith("get")) {
                String name = StringUtil.getGetterOrSetter(StringUtil.MethodType.SETTER,
                        method.getName().substring(3));
                Ignored ignored = method.getAnnotation(Ignored.class);
                if (ignored == null || !ignored.value()) {
                    try {
                        Method setter = entity.getClass().getMethod(name, method.getReturnType());
                        if (method.invoke(this) != null)
                            setter.invoke(entity, method.invoke(this));
                    } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
}