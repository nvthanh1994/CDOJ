package cn.edu.uestc.acmicpc.db.condition.base;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.BlockJUnit4ClassRunner;

import cn.edu.uestc.acmicpc.db.condition.base.Condition.ConditionType;
import cn.edu.uestc.acmicpc.db.condition.base.Condition.JoinedType;
import cn.edu.uestc.acmicpc.util.exception.AppException;

@RunWith(BlockJUnit4ClassRunner.class)
public class ConditionTest {

  @Test
  public void testToHQLString_empty() {
    Condition condition = new Condition();
    Assert.assertEquals("", condition.toHQLString());
  }

  @Test
  public void testToHQLString_simpleEntry() throws AppException {
    Condition condition = new Condition();
    condition.addEntry("id", ConditionType.EQUALS, 1);
    Assert.assertEquals("where (id='1')", condition.toHQLString());
  }

  @Test
  public void testToHQLString_pairEntries() throws AppException {
    Condition condition = new Condition();
    condition.addEntry("id", ConditionType.GREATER_OR_EQUALS, 1);
    condition.addEntry("id", ConditionType.LESS_OR_EQUALS, 5);
    Assert.assertEquals("where (id>='1' and id<='5')", condition.toHQLString());
  }

  @Test
  public void testToHQLString_pairEntries_or() throws AppException {
    Condition condition = new Condition(JoinedType.OR);
    condition.addEntry("id", ConditionType.GREATER_OR_EQUALS, 1);
    condition.addEntry("id", ConditionType.LESS_OR_EQUALS, 5);
    Assert.assertEquals("where (id>='1' or id<='5')", condition.toHQLString());
  }

  @Test
  public void testToHQLString_pairConditions() throws AppException {
    Condition condition = new Condition(JoinedType.AND);
    Condition first = new Condition(JoinedType.OR);
    Condition second = new Condition(JoinedType.OR);
    first.addEntry("id", ConditionType.GREATER_OR_EQUALS, 1);
    first.addEntry("id", ConditionType.LESS_OR_EQUALS, 5);
    second.addEntry("price", ConditionType.GREATER_THAN, 10);
    second.addEntry("price", ConditionType.LESS_OR_EQUALS, 20);
    condition.addEntry(first);
    condition.addEntry(second);
    Assert.assertEquals(
        "where ((id>='1' or id<='5') and (price>'10' or price<='20'))",
        condition.toHQLString());
  }

  @Test
  public void testToHQLString_pairConditions_bothNull() throws AppException {
    Condition condition = new Condition();
    condition.addEntry(new Condition());
    condition.addEntry(new Condition());
    Assert.assertEquals("", condition.toHQLString());
  }

  @Test
  public void testToHQLString_conditionType_isNotNull() throws AppException {
    Condition condition = new Condition();
    condition.addEntry("userId", ConditionType.IS_NOT_NULL, null);
    Assert.assertEquals("where ((userId is not null))", condition.toHQLString());
  }

  @Test
  public void testToHQLString_conditionType_isNull() throws AppException {
    Condition condition = new Condition();
    condition.addEntry("userId", ConditionType.IS_NULL, null);
    Assert.assertEquals("where ((userId is null))", condition.toHQLString());
  }

  @Test
  public void testToHQLString_conditionType_bothNull() throws AppException {
    Condition condition = new Condition();
    condition.addEntry("userId", ConditionType.IS_NOT_NULL, null);
    condition.addEntry("departmentId", ConditionType.IS_NULL, null);
    Assert.assertEquals("where ((userId is not null) and (departmentId is null))",
        condition.toHQLString());
  }

  @Test
  public void testToHQLStringWithOrder_empty() {
    Condition condition = new Condition();
    Assert.assertEquals("", condition.toHQLStringWithOrders());
  }

  @Test
  public void testToHQLStringWithOrder_simpleEntry() throws AppException {
    Condition condition = new Condition();
    condition.addEntry("userId", ConditionType.GREATER_OR_EQUALS, 1);
    condition.addOrder("userId", false);
    Assert.assertEquals("where (userId>='1') order by userId desc",
        condition.toHQLStringWithOrders());
  }

  @Test
  public void testToHQLStringWithOrder_simpleEntry_multipleOrders() throws AppException {
    Condition condition = new Condition();
    condition.addEntry("userId", ConditionType.GREATER_OR_EQUALS, 1);
    condition.addOrder("departmentId", true);
    condition.addOrder("userId", false);
    Assert.assertEquals("where (userId>='1') order by departmentId asc,userId desc",
        condition.toHQLStringWithOrders());
  }

  @Test
  public void testToHQLStringWithOrder_multipleEntry_multipleOrders() throws AppException {
    Condition condition = new Condition();
    Condition first = new Condition(JoinedType.OR);
    Condition second = new Condition(JoinedType.OR);
    first.addEntry("userId", ConditionType.GREATER_OR_EQUALS, 1);
    first.addEntry("userId", ConditionType.LESS_OR_EQUALS, 5);
    second.addEntry("departmentId", ConditionType.IS_NOT_NULL, null);
    second.addEntry("userName", ConditionType.LIKE, "user");
    condition.addEntry(first);
    condition.addEntry(second);
    condition.addOrder("departmentId", true);
    condition.addOrder("userId", false);
    Assert.assertEquals(
        "where ((userId>='1' or userId<='5') and ((departmentId is not null)"
        + " or userName like '%user%')) order by departmentId asc,userId desc",
        condition.toHQLStringWithOrders());
  }
}