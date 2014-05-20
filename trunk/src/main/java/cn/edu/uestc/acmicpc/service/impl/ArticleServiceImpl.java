package cn.edu.uestc.acmicpc.service.impl;

import cn.edu.uestc.acmicpc.db.condition.impl.ArticleCondition;
import cn.edu.uestc.acmicpc.db.criteria.impl.ArticleCriteria;
import cn.edu.uestc.acmicpc.db.dao.iface.IArticleDAO;
import cn.edu.uestc.acmicpc.db.dto.field.ArticleFields;
import cn.edu.uestc.acmicpc.db.dto.impl.ArticleDto;
import cn.edu.uestc.acmicpc.db.entity.Article;
import cn.edu.uestc.acmicpc.service.iface.ArticleService;
import cn.edu.uestc.acmicpc.util.exception.AppException;
import cn.edu.uestc.acmicpc.util.exception.AppExceptionUtil;
import cn.edu.uestc.acmicpc.web.dto.PageInfo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ArticleServiceImpl extends AbstractService implements ArticleService {

  private final IArticleDAO articleDAO;

  @Autowired
  public ArticleServiceImpl(IArticleDAO articleDAO) {
    this.articleDAO = articleDAO;
  }

  @Override
  public IArticleDAO getDAO() {
    return articleDAO;
  }

  @Override
  public ArticleDto getArticleDto(Integer articleId,
                                  ArticleFields articleFields)
      throws AppException {
    ArticleCriteria articleCriteria = new ArticleCriteria(articleFields);
    articleCriteria.startId = articleId;
    articleCriteria.endId = articleId;
    return articleDAO.getDtoByUniqueField(articleCriteria.getCriteria());
  }

  @Override
  public Long count(ArticleCriteria articleCriteria) throws AppException {
    return articleDAO.count(articleCriteria.getCriteria());
  }

  @Override
  public List<ArticleDto> getArticleList(ArticleCriteria articleCriteria,
                                             PageInfo pageInfo) throws AppException {
    return articleDAO.findAll(articleCriteria.getCriteria(), pageInfo);
  }

  @Override
  public void operator(String field, String ids, String value) throws AppException {
    Map<String, Object> properties = new HashMap<>();
    properties.put(field, value);
    articleDAO.updateEntitiesByField(properties, "articleId", ids);
  }

  @Override
  public Integer createNewArticle(Integer authorId) throws AppException {
    Article article = new Article();
    article.setTitle("");
    article.setContent("");
    article.setTime(new Timestamp(new Date().getTime()));
    article.setClicked(0);
    article.setOrder(0);
    article.setType(1);
    article.setIsVisible(true);
    article.setUserId(authorId);
    articleDAO.add(article);
    return article.getArticleId();
  }

  private void updateArticleByArticleDTO(Article article, ArticleDto articleDto) {
    if (articleDto.getParentId() != null) {
      article.setParentId(articleDto.getParentId());
    }
    if (articleDto.getClicked() != null) {
      article.setClicked(articleDto.getClicked());
    }
    if (articleDto.getContent() != null) {
      article.setContent(articleDto.getContent());
    }
    if (articleDto.getType() != null) {
      article.setType(articleDto.getType());
    }
    if (articleDto.getIsVisible() != null) {
      article.setIsVisible(articleDto.getIsVisible());
    }
    if (articleDto.getOrder() != null) {
      article.setOrder(articleDto.getOrder());
    }
    if (articleDto.getProblemId() != null) {
      article.setProblemId(articleDto.getProblemId());
    }
    if (articleDto.getContestId() != null) {
      article.setContestId(articleDto.getContestId());
    }
    if (articleDto.getTime() != null) {
      article.setTime(articleDto.getTime());
    }
    if (articleDto.getTitle() != null) {
      article.setTitle(articleDto.getTitle());
    }
    if (articleDto.getUserId() != null) {
      article.setUserId(articleDto.getUserId());
    }
  }

  @Override
  public void updateArticle(ArticleDto articleDto) throws AppException {
    AppExceptionUtil.assertNotNull(articleDto);
    AppExceptionUtil.assertNotNull(articleDto.getArticleId());
    Article article = articleDAO.get(articleDto.getArticleId());
    AppExceptionUtil.assertNotNull(article);
    updateArticleByArticleDTO(article, articleDto);
    articleDAO.update(article);
  }

  @Override
  public void incrementClicked(Integer articleId) throws AppException {
    articleDAO.increment("clicked", "articleId", articleId.toString());
  }

  @Override
  public Boolean checkArticleExists(Integer articleId) throws AppException {
    AppExceptionUtil.assertNotNull(articleId);
    ArticleCondition articleCondition = new ArticleCondition();
    articleCondition.startId = articleId;
    articleCondition.endId = articleId;
    return articleDAO.count(articleCondition.getCondition()) == 1;
  }

}
