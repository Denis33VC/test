<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="xml" indent="yes" encoding="koi8-r"/>

<xsl:variable name="border-width" select="0.3" />
<xsl:variable name="razmer_head" select="10" />
<xsl:variable name="razmer_grid" select="10" />

<xsl:variable name="date" select="nakl_m15/documentdata/rekv/date" />
<xsl:variable name="sec" select="nakl_m15/documentdata/rekv/sec" />
<xsl:variable name="sec_dsp" select="nakl_m15/documentdata/rekv/sec_dsp" />
<xsl:variable name="x76302" select="nakl_m15/documentdata/rekv/x76302" />
<xsl:variable name="x739" select="nakl_m15/documentdata/rekv/x739" />
<xsl:variable name="x481" select="nakl_m15/documentdata/rekv/x481" />
<xsl:variable name="vik" select="nakl_m15/documentdata/rekv/vik" />
<xsl:variable name="osnov" select="nakl_m15/documentdata/rekv/osnov" />
<xsl:variable name="x481_zak" select="nakl_m15/documentdata/rekv/x481_zak" />
<xsl:variable name="ceh" select="nakl_m15/documentdata/rekv/ceh" />

<xsl:template match="nakl_m15">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">	
        <fo:layout-master-set>
	    <!-- === SINGLE === -->
	    <fo:simple-page-master master-name="single" page-width="297mm"
		margin-left="15mm" margin-right="10mm"
		page-height="210mm" margin-top="10mm"
		margin-bottom="10mm">
		<xsl:choose>
		    <xsl:when test="$sec>=0 and $sec_dsp=1">
			<fo:region-body margin-top="25mm" margin-bottom="25mm" region-name="main_region" />
		    </xsl:when>
		    <xsl:otherwise>
			<fo:region-body margin-top="15mm" margin-bottom="15mm" region-name="main_region" />
		    </xsl:otherwise>
		</xsl:choose>
		<fo:region-before extent="35mm" region-name="first_header" />
	    </fo:simple-page-master>
	    
	    <!-- === FIRST PAGE MASTER === -->	    
	    <fo:simple-page-master master-name="first" page-width="297mm"
		margin-left="15mm" margin-right="10mm"
		page-height="210mm" margin-top="10mm"
		margin-bottom="10mm">
		<xsl:choose>
		    <xsl:when test="$sec>=0 and $sec_dsp=1">
			<fo:region-body margin-top="25mm" margin-bottom="25mm" region-name="main_region" />
		    </xsl:when>
		    <xsl:otherwise>
			<fo:region-body margin-top="15mm" margin-bottom="15mm" region-name="main_region" />
		    </xsl:otherwise>
		</xsl:choose>
		<fo:region-before extent="35mm" region-name="first_header" />
	    </fo:simple-page-master>
	    
	    <!-- === REST PAGES MASTER === -->
	    <fo:simple-page-master master-name="rest" page-width="297mm"
		margin-left="15mm" margin-right="10mm"
		page-height="210mm" margin-top="10mm"
		margin-bottom="10mm">
		<fo:region-body margin-top="10mm" margin-bottom="15mm" region-name="main_region" />		
	    </fo:simple-page-master>
	    
	    <!-- === LAST PAGE MASTER === -->
	    <fo:simple-page-master master-name="last" page-width="297mm"
		margin-left="15mm" margin-right="10mm"
		page-height="210mm" margin-top="10mm"
		margin-bottom="10mm" widows="3">
		<fo:region-body margin-top="10mm" margin-bottom="15mm" region-name="main_region" />
		<fo:region-after  extent="15mm" region-name="last_footer" />
	    </fo:simple-page-master>
            <!-- *************************************************  -->
	    <fo:page-sequence-master master-name="sequence">
		<fo:repeatable-page-master-alternatives>		    
		    <!-- Если несколько страниц -->
		    <fo:conditional-page-master-reference 
			master-reference="first" 
			page-position="first" />		    
		    <fo:conditional-page-master-reference 
			master-reference="last" 
			page-position="last" />
		    <fo:conditional-page-master-reference 
			master-reference="rest" />
		</fo:repeatable-page-master-alternatives>
	    </fo:page-sequence-master>
        </fo:layout-master-set>

            <fo:page-sequence master-reference="sequence" id="seq_id">		
                <!-- Заголовок ТОЛЬКО для первой страницы -->
                <fo:static-content flow-name="first_header" font-family="Times" font-size="8pt">               
		    <fo:table text-align="right">
			<fo:table-column column-width="50mm"/>
			<fo:table-column column-width="150mm"/>
			<fo:table-column column-width="70mm"/>
			    <fo:table-body>
				<fo:table-row>
				    <fo:table-cell>
					<fo:block>&#160;</fo:block>
				    </fo:table-cell>
				    
				    <fo:table-cell font-size="11pt" font-weight="bold" number-rows-spanned="6" text-align="center">
					<xsl:if test="$sec>=0 and $sec_dsp=1">
					    <fo:block>&#160;</fo:block>
					    <fo:block>&#160;</fo:block>
					</xsl:if>
					<fo:block margin-top="1mm">НАКЛАДНАЯ № <xsl:value-of select="$x739"/></fo:block>
					<fo:block margin-top="1mm">на отпуск материалов на сторону</fo:block>
					<fo:block>&#160;</fo:block>
					<fo:block>&#160;</fo:block>
				    </fo:table-cell>
				    
				    <fo:table-cell number-rows-spanned="6">
					<xsl:if test="$sec>=0 and $sec_dsp=1">
					    <fo:block margin-top="2mm">ДЛЯ СЛУЖЕБНОГО ПОЛЬЗОВАНИЯ</fo:block>
					    <fo:block margin-top="1mm">Экз. NN1</fo:block>
					    <fo:block margin-top="1mm">&#160;</fo:block>
					</xsl:if>
					<fo:block margin-top="1mm">Типовая межотраслевая форма № М-15</fo:block>
					<fo:block margin-top="1mm">Утверждена постановлением Госкомстата России</fo:block>
					<fo:block margin-top="1mm">от 30.10.97 № 71а</fo:block>
				    </fo:table-cell>
				</fo:table-row>
			    </fo:table-body>
		    </fo:table> 	      
		</fo:static-content>

                <!-- Подвал для ПОСЛЕДНЕЙ страницы -->
                <fo:static-content flow-name="last_footer" font-family="Times" font-size="8pt">    	     
                    <fo:table border-style="none" text-align="left">			
                        <fo:table-column column-width="260mm"/>     
			    <fo:table-body>
				<fo:table-row>
				    <fo:table-cell>
					<xsl:if test="$sec>=0 and $sec_dsp=1">
					    <fo:block margin-top="1mm">___ экз. на 1 стр. каждый</fo:block>
					    <fo:block margin-top="1mm">МОНАХОВ Д.А.</fo:block>
					    <fo:block margin-top="1mm"><xsl:value-of select="$date"/></fo:block>
					</xsl:if>
				    </fo:table-cell>
				</fo:table-row>
			    </fo:table-body>
                    </fo:table>	    
                </fo:static-content>

                <fo:flow flow-name="main_region">
		    <xsl:apply-templates select="//rekv"/>		    
                    <xsl:apply-templates select="//tab" />
                    <fo:block id="flow_end"/>
                </fo:flow>
        </fo:page-sequence>
    </fo:root>
</xsl:template>

<xsl:template match="rekv">
    <fo:table text-align="center" font-family="Times" font-size="11pt">			
	<fo:table-column column-width="25mm"/>
	<fo:table-column column-width="165mm"/>
	<fo:table-column column-width="20mm"/>
	<fo:table-column column-width="60mm"/>
	    <fo:table-body>
		<fo:table-row>
		    <fo:table-cell display-align="after" text-align="left">
			<fo:block margin-top="1mm">Организация</fo:block>
		    </fo:table-cell>
		    
		    <fo:table-cell wrap-option="wrap" border-bottom="solid" display-align="after" font-size="9pt" number-columns-spanned="2">					
			<fo:block><xsl:value-of select="$x481"/></fo:block>
		    </fo:table-cell>
		    
		    <fo:table-cell>
			<fo:table font-family="Times" font-size="11pt">			
			    <fo:table-column column-width="30mm"/>
			    <fo:table-column column-width="30mm"/>
				<fo:table-body>
				    <fo:table-row>
					<fo:table-cell>
					    <fo:block margin-top="1mm">&#160;</fo:block>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid">
					    <fo:block margin-top="1mm">Коды</fo:block>
					</fo:table-cell>
				    </fo:table-row>
				    
				    <fo:table-row>
					<fo:table-cell text-align="right">
					    <fo:block margin-top="1mm" margin-right="2mm">Форма по ОКУД</fo:block>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid">
					    <fo:block margin-top="1mm">0315007</fo:block>
					</fo:table-cell>
				    </fo:table-row>
				    
				    <fo:table-row>
					<fo:table-cell text-align="right">
					    <fo:block margin-top="1mm" margin-right="2mm">по ОКПО</fo:block>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid">
					    <fo:block margin-top="1mm">25990854</fo:block>
					</fo:table-cell>
				    </fo:table-row>						    
				</fo:table-body>
			</fo:table>										    
		    </fo:table-cell>				    
		</fo:table-row>
		
		<!--СТРОКА-РАЗДЕЛИТЕЛЬ-->
		<fo:table-row height="5pt">
		    <fo:table-cell number-columns-spanned="4">
			<fo:block>&#160;</fo:block>
		    </fo:table-cell>				    
		</fo:table-row>
		
		<fo:table-row>					    
		    <fo:table-cell number-columns-spanned="4">
			<fo:table font-family="Times" font-size="9pt">
			    <fo:table-column column-width="68mm"/>
			    
			    <fo:table-column column-width="20mm"/>
			    <fo:table-column column-width="20mm"/>
			    
			    <fo:table-column column-width="24mm"/>
			    <fo:table-column column-width="24mm"/>
			    <fo:table-column column-width="24mm"/>
			    <fo:table-column column-width="24mm"/>
			    <fo:table-column column-width="22mm"/>
			    <fo:table-column column-width="22mm"/>
			    <fo:table-column column-width="22mm"/>
				<fo:table-body>
				    <fo:table-row>
					<fo:table-cell>
					    <fo:block margin-top="1mm">&#160;</fo:block>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid" wrap-option="wrap">
					    <fo:block margin-top="1mm">Дата составления</fo:block>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid" wrap-option="wrap">
					    <fo:block margin-top="1mm">Код вида операции</fo:block>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid" number-columns-spanned="2">
					    <fo:table font-family="Times" font-size="9pt">
						<fo:table-column column-width="50%"/>
						<fo:table-column column-width="50%"/>
						    <fo:table-body>
							<fo:table-row>
							    <fo:table-cell border-bottom="solid" number-columns-spanned="2">
								<fo:block margin-top="1mm">Отправитель</fo:block>
							    </fo:table-cell>									    
							</fo:table-row>
							
							<fo:table-row>
							    <fo:table-cell border-right="solid" wrap-option="wrap">
								<fo:block margin-top="1mm">структурное подразделение</fo:block>
							    </fo:table-cell>
							    
							    <fo:table-cell wrap-option="wrap">
								<fo:block margin-top="1mm">вид &#160; деятельности</fo:block>
							    </fo:table-cell>
							</fo:table-row>									
						    </fo:table-body>							    
					    </fo:table>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid" number-columns-spanned="2">
					    <fo:table font-family="Times" font-size="9pt">
						<fo:table-column column-width="50%"/>
						<fo:table-column column-width="50%"/>
						    <fo:table-body>
							<fo:table-row>
							    <fo:table-cell border-bottom="solid" number-columns-spanned="2">
								<fo:block margin-top="1mm">Получатель</fo:block>
							    </fo:table-cell>									    
							</fo:table-row>
							
							<fo:table-row>
							    <fo:table-cell border-right="solid" wrap-option="wrap">
								<fo:block margin-top="1mm">структурное подразделение</fo:block>
							    </fo:table-cell>
							    
							    <fo:table-cell wrap-option="wrap">
								<fo:block margin-top="1mm">вид &#160; деятельности</fo:block>
							    </fo:table-cell>
							</fo:table-row>									
						    </fo:table-body>							    
					    </fo:table>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid" number-columns-spanned="3">
					    <fo:table font-family="Times" font-size="9pt">
						<fo:table-column column-width="33%"/>
						<fo:table-column column-width="33%"/>
						<fo:table-column column-width="33%"/>
						    <fo:table-body>
							<fo:table-row>
							    <fo:table-cell border-bottom="solid" number-columns-spanned="3">
								<fo:block margin-top="1mm">Ответственный за поставку</fo:block>
							    </fo:table-cell>									    
							</fo:table-row>
							
							<fo:table-row>
							    <fo:table-cell border-right="solid" wrap-option="wrap">
								<fo:block margin-top="1mm">структурное подразделение</fo:block>
							    </fo:table-cell>
							    
							    <fo:table-cell border-right="solid" wrap-option="wrap">
								<fo:block margin-top="1mm">вид деятельности</fo:block>
							    </fo:table-cell>
							    
							    <fo:table-cell border-top="solid" wrap-option="wrap">
								<fo:block margin-top="1mm">код исполнителя</fo:block>
							    </fo:table-cell>
							</fo:table-row>									
						    </fo:table-body>							    
					    </fo:table>
					</fo:table-cell>
				    </fo:table-row>
				    
				    <fo:table-row>
					<fo:table-cell>
					    <fo:block margin-top="1mm">&#160;</fo:block>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid">
					    <fo:block margin-top="1mm">&#160;</fo:block>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid" font-weight="bold" font-style="italic">
					    <fo:block margin-top="1mm">23</fo:block>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid" font-weight="bold" font-style="italic">
					    <xsl:choose>                        
						<xsl:when test="$ceh=18">
						    <fo:block margin-top="1mm">518</fo:block>
						</xsl:when>
					    <xsl:otherwise>
						    <fo:block margin-top="1mm">115</fo:block>
						</xsl:otherwise>
					    </xsl:choose>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid">
					    <fo:block margin-top="1mm">&#160;</fo:block>							    						    
					</fo:table-cell>
					
					<fo:table-cell border-style="solid">
					    <fo:block margin-top="1mm">&#160;</fo:block>							    						    
					</fo:table-cell>
					
					<fo:table-cell border-style="solid">
					    <fo:block margin-top="1mm">&#160;</fo:block>							    						    
					</fo:table-cell>
					
					<fo:table-cell border-style="solid" font-weight="bold" font-style="italic">
					    <xsl:choose>                        
						<xsl:when test="$ceh=18">
						    <fo:block margin-top="1mm">18</fo:block>
						</xsl:when>
					    <xsl:otherwise>
						    <fo:block margin-top="1mm">90</fo:block>
						</xsl:otherwise>
					    </xsl:choose>
					</fo:table-cell>
					
					<fo:table-cell border-style="solid" font-weight="bold" font-style="italic">
					    <fo:block margin-top="1mm"><xsl:value-of select="$vik"/></fo:block>						    						    
					</fo:table-cell>
					
					<fo:table-cell border-style="solid">
					    <fo:block margin-top="1mm">&#160;</fo:block>							    						    
					</fo:table-cell>
				    </fo:table-row>
				</fo:table-body>
			</fo:table>										    
		    </fo:table-cell>				    
		</fo:table-row>
		
		<!--СТРОКА-РАЗДЕЛИТЕЛЬ-->
		<fo:table-row height="5pt">
		    <fo:table-cell number-columns-spanned="4">
			<fo:block>&#160;</fo:block>
		    </fo:table-cell>				    
		</fo:table-row>
		
		<fo:table-row text-align="left">
		    <fo:table-cell display-align="after">
			<fo:block margin-top="1mm">Основание</fo:block>
		    </fo:table-cell>
		    
		    <fo:table-cell wrap-option="wrap" border-bottom="solid" display-align="after" number-columns-spanned="3">					
			<fo:block><xsl:value-of select="$osnov"/></fo:block>
		    </fo:table-cell> 
		</fo:table-row>
		
		<!--СТРОКА-РАЗДЕЛИТЕЛЬ-->
		<fo:table-row height="5pt">
		    <fo:table-cell number-columns-spanned="4">
			<fo:block>&#160;</fo:block>
		    </fo:table-cell>				    
		</fo:table-row>
		
		<fo:table-row text-align="left">
		    <fo:table-cell display-align="before">
			<fo:block margin-top="1mm">Кому</fo:block>
		    </fo:table-cell>
		    
		    <fo:table-cell wrap-option="wrap" border-bottom="solid" display-align="after" font-size="9pt" font-weight="bold" font-style="italic">
			<fo:block><xsl:value-of select="$x481_zak"/></fo:block>
		    </fo:table-cell>
		    
		    <fo:table-cell text-align="right" display-align="after">
			<fo:block margin-top="1mm">Через кого</fo:block>
		    </fo:table-cell>
		    
		    <fo:table-cell border-bottom="solid" display-align="after">
			<fo:block>&#160;</fo:block>
		    </fo:table-cell>
		</fo:table-row>
		
		<!--СТРОКА-РАЗДЕЛИТЕЛЬ-->
		<fo:table-row height="5pt">
		    <fo:table-cell number-columns-spanned="4">
			<fo:block>&#160;</fo:block>
		    </fo:table-cell>				    
		</fo:table-row>
	    </fo:table-body>
    </fo:table>    
</xsl:template>

<xsl:template match="tab">
    <fo:table table-omit-header-at-break="true" table-layout="fixed" text-align="center" font-family="Times" font-size="9pt" display-align="center">
	<fo:table-column column-width="13mm"/>
        <fo:table-column column-width="23mm"/>
        <fo:table-column column-width="55mm"/>
        <fo:table-column column-width="24mm"/>
        <fo:table-column column-width="7mm"/>
        <fo:table-column column-width="20mm"/>
        <fo:table-column column-width="16mm"/>
        <fo:table-column column-width="16mm"/>
	<fo:table-column column-width="23mm"/>
	<fo:table-column column-width="25mm"/>
	<fo:table-column column-width="24mm"/>
	<fo:table-column column-width="24mm"/>
	
	<fo:table-header>
	    <fo:table-row>		
		<fo:table-cell border-style="solid" wrap-option="wrap" number-columns-spanned="2">
                    <fo:block>Корреспондирующий счёт</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid" wrap-option="wrap" number-columns-spanned="2">
                    <fo:block>Материальные ценности</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid" wrap-option="wrap" number-columns-spanned="2">
                    <fo:block>Единица &#160;измерения</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid" number-columns-spanned="2">
                    <fo:block>Количество</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid" number-rows-spanned="2">
                    <fo:block>Цена, руб.коп.</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid" wrap-option="wrap" number-rows-spanned="2">
                    <fo:block>Сумма без учёта НДС, руб.коп.</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid" wrap-option="wrap" number-rows-spanned="2">
                    <fo:block>Сумма НДС, руб.коп.</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid" wrap-option="wrap" number-rows-spanned="2">
                    <fo:block>Всего с учётом НДС, руб.коп.</fo:block>
                </fo:table-cell>
	    </fo:table-row>
	    
	    <fo:table-row>		
		<fo:table-cell border-style="solid" wrap-option="wrap">
                    <fo:block>счёт, субсчёт</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid" wrap-option="wrap">
                    <fo:block>код аналитического учёта</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>Наименование, сорт, размер, марка</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid" wrap-option="wrap">
                    <fo:block>номенклатурный номер</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>код</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid" wrap-option="wrap">
                    <fo:block>наименование</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid" wrap-option="wrap">
                    <fo:block>надлежит отпустить</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>отпущено</fo:block>
		</fo:table-cell>
	    </fo:table-row>
	    
	    <fo:table-row >		
		<fo:table-cell border-style="solid">
                    <fo:block>1</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>2</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>3</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>4</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>5</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>6</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>7</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>8</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>9</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>10</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>11</fo:block>
                </fo:table-cell>
		
		<fo:table-cell border-style="solid">
                    <fo:block>12</fo:block>
                </fo:table-cell>
	    </fo:table-row>	
	</fo:table-header>
	
	<fo:table-body>
	    <xsl:apply-templates select="str1" />
	    <xsl:apply-templates select="itog" />
        </fo:table-body>	    
    </fo:table>
    
    <xsl:if test="not(position()=last())">
            <fo:block break-after="page" />
        </xsl:if>    
</xsl:template>

<xsl:template match="str1">
	<fo:table-row keep-together="always">		
	    <fo:table-cell border-style="solid">
		<fo:block>&#160;</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell border-style="solid">
		<fo:block>&#160;</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell text-align="left" wrap-option="wrap" border-style="solid">
		<fo:block><xsl:value-of select="naim" /></fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell border-style="solid">
		<fo:block>&#160;</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell border-style="solid">
		<fo:block><xsl:value-of select="kod_ei" /></fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell border-style="solid">
		<fo:block><xsl:value-of select="naim_kod_ei" /></fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell border-style="solid">
		<fo:block><xsl:value-of select="kolvo" /></fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell border-style="solid">
		<fo:block><xsl:value-of select="kolvo" /></fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell border-style="solid">
		<fo:block><xsl:value-of select="cena" /></fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell border-style="solid">
		<fo:block><xsl:value-of select="sum_bez_nds" /></fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell border-style="solid">
		<fo:block><xsl:value-of select="sum_nds" /></fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell border-style="solid">
		<fo:block><xsl:value-of select="vsego_s_nds" /></fo:block>
	    </fo:table-cell>
	</fo:table-row>
</xsl:template>

<xsl:template match="itog">
	<!--СТРОКА-РАЗДЕЛИТЕЛЬ-->
	<fo:table-row height="25pt" keep-together="always">
	    <fo:table-cell number-columns-spanned="12">
		<fo:block>&#160;</fo:block>
	    </fo:table-cell>				    
	</fo:table-row>
	
	<fo:table-row text-align="left" keep-together="always">
	    <fo:table-cell number-columns-spanned="2">
		<fo:block>Всего отпущено</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell text-align="center" border-bottom-style="solid" number-columns-spanned="2">
		<fo:block>&#160;</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell number-columns-spanned="2">
		<fo:block>наименований</fo:block>
	    </fo:table-cell>
	</fo:table-row>
	
	<!--СТРОКА-РАЗДЕЛИТЕЛЬ-->
	<fo:table-row height="15pt" keep-together="always">
	    <fo:table-cell number-columns-spanned="12">
		<fo:block>&#160;</fo:block>
	    </fo:table-cell>				    
	</fo:table-row>
	
	<fo:table-row text-align="left" keep-together="always">
	    <fo:table-cell display-align="after" number-columns-spanned="2">
		<fo:block>на сумму</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell text-align="center" wrap-option="wrap" border-bottom-style="solid" number-columns-spanned="2">
		<fo:block>dddddddddddddd ddddddddddddddddddddddd dddddddddddddddddddddddddddddd</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell>
		<fo:block>&#160;</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell text-align="right" display-align="after" number-columns-spanned="3">
		<fo:block>в том числе сумма НДС</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell text-align="center" wrap-option="wrap" border-bottom-style="solid" number-columns-spanned="4">
		<fo:block>dddddddddddddd ddddddddddddddddddddddd dddddddddddddddddddddddddddddd</fo:block>
	    </fo:table-cell>
	</fo:table-row>
	
	<!--СТРОКА-РАЗДЕЛИТЕЛЬ-->
	<fo:table-row height="15pt" keep-together="always">
	    <fo:table-cell number-columns-spanned="12">
		<fo:block>&#160;</fo:block>
	    </fo:table-cell>				    
	</fo:table-row>
	
	<fo:table-row text-align="center" keep-together="always">
	    <fo:table-cell text-align="left" display-align="after" number-columns-spanned="2">
		<fo:block font-weight="bold">Отпуск разрешил</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell text-align="left">
		<fo:block font-style="italic">начальник отдела №90</fo:block>
		<fo:block>_______________________</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell text-align="left" display-align="after">
		<fo:block>_____________</fo:block>
		<fo:block font-size="8pt">(подпись)</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell number-columns-spanned="2">
		<fo:block font-style="italic">Кочнева И.В.</fo:block>
		<fo:block>___________________</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell>
		<fo:block>&#160;</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell text-align="left" display-align="before" number-columns-spanned="2">
		<fo:block font-weight="bold">Главный бухгалтер</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell>
		<fo:block>_______________</fo:block>
		<fo:block font-size="8pt">(подпись)</fo:block>
	    </fo:table-cell>
	    
	    <fo:table-cell number-columns-spanned="2">
		<fo:block>__________________________</fo:block>
		<fo:block font-size="8pt">(расшифровка подписи)</fo:block>
	    </fo:table-cell>
	</fo:table-row>
	
	
</xsl:template>
</xsl:stylesheet>