package cn.edu.uestc.acmicpc.oj.service.iface;

import java.io.Serializable;

import cn.edu.uestc.acmicpc.db.dao.iface.IDAO;
import cn.edu.uestc.acmicpc.db.dto.base.BaseDTO;

/**
 * Online judge global service.
 *
 * @param <E> Entity type
 * @param <K> Key type
 * @param <D> Dto type
 */
public interface OnlineJudgeService<E extends Serializable, K extends Serializable, D extends BaseDTO<E>> {

  /**
   * Get entity dao for query.
   *
   * @return enitty dao for query.
   */
  IDAO<E, K, D> getDAO();
}
