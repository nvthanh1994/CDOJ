# Move most common functions in a base list module
initProblemList = ->
  $problemList = $("#problem-list")
  if $problemList.length != 0
    problemList = new ListModule(
      listContainer: $problemList
      requestUrl: "/problem/search"
      condition:
        currentPage: null,
        startId: undefined,
        endId: undefined,
        title: undefined,
        source: undefined,
        isSpj: undefined,
        startDifficulty: undefined,
        endDifficulty: undefined,
        keyword: undefined,
        orderFields: undefined,
        orderAsc: undefined
      formatter: (data) ->
        #console.log(data);
        panelAC = "panel panel-success"
        panelWA = "panel panel-danger"
        panelDE = "panel panel-default"
        # data.status = 1 if AC, 2 if TRIED, otherwise null
        @user = getCurrentUser()
        adminSpan = ->
          result = ""
          if @user.userLogin && @user.currentUserType == "1"
            # admin
            result += """
                      <div class="btn-toolbar" role="toolbar">
                        <div class="btn-group">
                          <button type="button" class="btn btn-default btn-sm problem-visible-state-editor" problem-id="#{data.problemId}" visible="#{data.isVisible}">
                            <i class="#{if data.isVisible then "icon-eye-open" else "icon-eye-close"}"></i>
                          </button>
                          <button type="button" class="btn btn-default btn-sm problem-editor" problem-id="#{data.problemId}"><i class="icon-pencil"></i></button>
                          <button type="button" class="btn btn-default btn-sm problem-data-editor" problem-id="#{data.problemId}"><i class="icon-cog"></i></button>
                        </div>
                      </div>
                      """
          return result

        difficulty = (value) ->
          star = "<i class='icon-star'></i>"
          starEmpty = "<i class='icon-star-empty'></i>"
          value = Math.max(1, Math.min(5, value))
          result = ""
          value.times =>
            result += star
          (5 - value).times =>
            result += starEmpty
          return result

        """
          <div class="col-md-12">
            <div class="#{if data.status == 1
                           panelAC
                         else if data.status == 2
                           panelWA
                         else
                           panelDE
                         }">
              <div class="panel-heading">
                <h3 class="panel-title">
                  <a href="/problem/show/#{data.problemId}">#{data.title}</a>
                  <span class='pull-right admin-span'>#{adminSpan()}</span>
                  <span class='pull-right'>#{difficulty(data.difficulty)}</span>
                </h3>
              </div>
              <div class="panel-body">
                <span class="source">
                  #{if data.source.trim() != '' then data.source else ''}
                </span>
                #{if data.isSpj then "<span class='label label-danger'>SPJ</span>" else ''}
              </div>
            </div>
          </div>
        """
      after: ->
        @user = getCurrentUser()
        if @user.userLogin && @user.currentUserType == "1"
          $(".problem-editor").click (e) =>
            $el = $(e.currentTarget)
            window.location.href = "/problem/editor/#{$el.attr("problem-id")}"
            return false
          $(".problem-data-editor").click (e) =>
            $el = $(e.currentTarget)
            window.location.href = "/problem/dataEditor/#{$el.attr("problem-id")}"
            return false
          $(".problem-visible-state-editor").click (e) =>
            $el = $(e.currentTarget)
            visible = if $el.attr("visible") == "true" then true else false
            queryString = "/problem/operator/#{$el.attr("problem-id")}/isVisible/#{!visible}"
            $.post(queryString, (data) ->
              if data.result == "success"
                visible = !visible
                $el.attr("visible", visible)
                $el.empty().append("<i class=\"#{if visible then "icon-eye-open" else "icon-eye-close"}\"></i>")
            )
            return false
    )
