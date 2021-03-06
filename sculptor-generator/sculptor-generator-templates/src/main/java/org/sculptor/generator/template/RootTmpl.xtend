/*
 * Copyright 2013 The Sculptor Project Team, including the original 
 * author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.sculptor.generator.template

import javax.inject.Inject
import org.sculptor.generator.chain.ChainOverridable
import org.sculptor.generator.ext.Helper
import org.sculptor.generator.ext.Properties
import org.sculptor.generator.template.common.ExceptionTmpl
import org.sculptor.generator.template.common.LogConfigTmpl
import org.sculptor.generator.template.consumer.ConsumerTmpl
import org.sculptor.generator.template.db.DDLTmpl
import org.sculptor.generator.template.db.DatasourceTmpl
import org.sculptor.generator.template.db.DbUnitTmpl
import org.sculptor.generator.template.doc.ModelDocTmpl
import org.sculptor.generator.template.doc.UMLGraphTmpl
import org.sculptor.generator.template.domain.DomainObjectTmpl
import org.sculptor.generator.template.domain.DomainObjectAttributeConverterTmpl
import org.sculptor.generator.template.jpa.JPATmpl
import org.sculptor.generator.template.repository.AccessObjectTmpl
import org.sculptor.generator.template.repository.RepositoryTmpl
import org.sculptor.generator.template.rest.ResourceTmpl
import org.sculptor.generator.template.rest.RestWebTmpl
import org.sculptor.generator.template.service.ServiceEjbTestTmpl
import org.sculptor.generator.template.service.ServiceTmpl
import org.sculptor.generator.template.spring.SpringTmpl
import sculptormetamodel.Application
import sculptormetamodel.Enum

@ChainOverridable
class RootTmpl {

	@Inject var AccessObjectTmpl accessObjectTmpl
	@Inject var ConsumerTmpl consumerTmpl
	@Inject var DatasourceTmpl datasourceTmpl
	@Inject var DbUnitTmpl dbUnitTmpl
	@Inject var DDLTmpl dDLTmpl
	@Inject var DomainObjectTmpl domainObjectTmpl
	@Inject var DomainObjectAttributeConverterTmpl domainObjectAttributeConverterTmpl
	@Inject var ExceptionTmpl exceptionTmpl
	@Inject var JPATmpl jPATmpl
	@Inject var LogConfigTmpl logConfigTmpl
	@Inject var ModelDocTmpl modelDocTmpl
	@Inject var RepositoryTmpl repositoryTmpl
	@Inject var ResourceTmpl resourceTmpl
	@Inject var RestWebTmpl restWebTmpl
	@Inject var ServiceEjbTestTmpl serviceEjbTestTmpl
	@Inject var SpringTmpl springTmpl
	@Inject var UMLGraphTmpl uMLGraphTmpl
	@Inject var ServiceTmpl serviceTmpl

	@Inject extension Properties properties
	@Inject extension Helper helper

	def String root(Application it) {
		'''
		�IF !modules.isEmpty�
			�IF isDomainObjectToBeGenerated()�
				�it.getAllDomainObjects(false).forEach[domainObjectTmpl.domainObject(it)]�
				�IF isJpaAnnotationToBeGenerated()�
					�it.getAllDomainObjects(false).filter[it instanceof Enum].map[it as Enum].filter[!it.isOrdinaryEnum()].forEach[domainObjectAttributeConverterTmpl.domainObjectAttributeConverter(it)]�
				�ENDIF�
			�ENDIF�
			�IF isExceptionToBeGenerated()�
				�it.modules.filter[e|!e.external].forEach[exceptionTmpl.applicationExceptions(it)]�
			�ENDIF�
			�IF isRepositoryToBeGenerated()�
				�it.getAllRepositories(false).map[operations].flatten.filter[op | op.delegateToAccessObject && !op.isGenericAccessObject()].map[accessObjectTmpl.command(it)]�
				�it.getAllRepositories(false).forEach[repositoryTmpl.repository(it)]�
			�ENDIF�
			�IF isServiceToBeGenerated()�
				�it.getAllServices(false).forEach[serviceTmpl.service(it)]�
			�ENDIF�
			�IF isResourceToBeGenerated()�
				�it.getAllResources(false).forEach[resourceTmpl.resource(it)]�
			�ENDIF�
			�IF isRestWebToBeGenerated() && !it.getAllResources(false).isEmpty�
				�restWebTmpl.restWeb(it)�
			�ENDIF�
			�IF isConsumerToBeGenerated()�
				�it.getAllConsumers(false).forEach[consumerTmpl.consumer(it)]�
			�ENDIF�
			�IF isEmptyDbUnitTestDataToBeGenerated()�
				�dbUnitTmpl.emptyDbunitTestData(it)�
			�ENDIF�
			�IF getDbUnitDataSetFile() !== null�
				�dbUnitTmpl.singleDbunitTestData(it)�
			�ENDIF�
			�IF pureEjb3() && isTestToBeGenerated()�
				�IF jpa()�
					�logConfigTmpl.logbackTestXml(it)�
				�ELSE�
					�serviceEjbTestTmpl.ejbJarXml(it)�
				�ENDIF�
			�ENDIF�
			�IF isSpringToBeGenerated()�
				�springTmpl.spring(it)�
			�ENDIF�
			�IF isDdlToBeGenerated()�
				�dDLTmpl.ddl(it)�
			�ENDIF�
			�IF isDatasourceToBeGenerated()�
				�datasourceTmpl.datasource(it)�
			�ENDIF�
			�IF isLogbackConfigToBeGenerated()�
				�logConfigTmpl.logbackConfig(it)�
			�ENDIF�
			�IF isJpaAnnotationToBeGenerated()�
				�jPATmpl.jpa(it)�
			�ENDIF�
			�IF isUMLToBeGenerated()�
				�uMLGraphTmpl.start(it)�
			�ENDIF�
			�IF isModelDocToBeGenerated()�
				�modelDocTmpl.start(it)�
			�ENDIF�
		�ENDIF�
		'''
	}
}
