Class {
	#name : #PPXmlResource,
	#superclass : #TestResource,
	#instVars : [
		'parsers'
	],
	#category : #'PetitXml-Tests'
}

{ #category : #accessing }
PPXmlResource >> allXsdDefinitions [
	^ (self class organization listAtCategoryNamed: #'accessing-xsd')
		collect: [ :each | self perform: each ]
]

{ #category : #'accessing-xsd' }
PPXmlResource >> elementFormXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema
    xmlns="http://www.w3.org/2001/XMLSchema"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:tns="http://unqualified-elements.example.com"
    targetNamespace="http://unqualified-elements.example.com">

    <element name="unQualifiedLocals">
        <complexType>
            <sequence>
                <element name="unqualified" type="xsd:string"/>
                <element name="qualified" form="qualified" type="xsd:int"/>
<!--                <element ref="tns:global"/>-->
            </sequence>
        </complexType>
    </element>

    <element name="global" type="xsd:int"/>

</schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> elementReferencesXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema
        xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:tns="http://soapinterop.org/types"
        targetNamespace="http://soapinterop.org/types">

    <complexType name="Struct">
        <sequence>
            <element name="varString" type="xsd:string"/>
            <element name="varInt" type="xsd:int"/>
            <element name="varFloat" type="xsd:float"/>
            <element name="varStruct" type="tns:Struct"/>
        </sequence>
    </complexType>

    <element name="attrTest" type="tns:Struct"/>

    <element name="attTests">
        <complexType>
            <sequence>
                <element ref="tns:attrTest" maxOccurs="5"></element>
            </sequence>
        </complexType>
    </element>



</schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> externalAttributesXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema
    xmlns="http://www.w3.org/2001/XMLSchema"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:tns="http://unqualified-elements.example.com"
    xmlns:test="http://test-namespace"
    targetNamespace="http://unqualified-elements.example.com"
    test:level="1">

    <element name="AnyAttContainer" test:level="2">
        <complexType>
            <sequence>
                <element name="chileValue" type="xsd:string"/>
            </sequence>
            <anyAttribute namespace="##other" processContents="lax"></anyAttribute>
        </complexType>
    </element>

    <element name="global" type="xsd:int"/>

</schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> forwardRefXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<!--
 * Copyright 2004,2005 The Apache Software Foundation.
 * Copyright 2006 International Business Machines Corp.
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
 *
-->

<schema xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:tns="http://soapinterop.org/types"
        targetNamespace="http://soapinterop.org/types">

    <simpleType name="zipCode">
      <restriction base="string">
        <length value="5"/>
        <pattern value="\d{5}"/>
      </restriction>
    </simpleType>
    <element name="myZipCode" type="tns:zipCode"/>

    <simpleType name="age">
      <restriction base="decimal">
        <totalDigits value="3"/>
      </restriction>
    </simpleType>
    <element name="myAge" type="tns:age"/>

    <simpleType name="distance">
      <restriction base="integer">
        <maxInclusive value="100" fixed="true"/>
        <minInclusive value="0"/>
      </restriction>
    </simpleType>
    <element name="myDistance" type="tns:distance"/>

    <simpleType name="weight">
      <restriction base="integer">
        <maxExclusive value="200"/>
        <minExclusive value="1"/>
      </restriction>
    </simpleType>
    <element name="myWeight" type="tns:weight"/>

    <simpleType name="creditCardNumber">
      <restriction base="integer">
        <pattern value="\d{15}"/>
      </restriction>
    </simpleType>
    <element name="myCreditCardNumber" type="tns:creditCardNumber"/>

    <simpleType name="noWhiteSpace">
      <restriction base="normalizedString">
        <whiteSpace value="collapse"/>
      </restriction>
    </simpleType>
    <element name="myWhiteSpace" type="tns:noWhiteSpace"/>

    <simpleType name="petWeight">
      <restriction base="tns:weight">
        <maxExclusive value="50"/>
        <minExclusive value="5"/>
      </restriction>
    </simpleType>

    <simpleType name="fixedDistance">
      <restriction base="tns:distance">
        <minInclusive value="1"/>
      </restriction>
    </simpleType>

    <simpleType name="height">
      <restriction base="decimal">
        <totalDigits value="3"/>
        <fractionDigits value="2"/>
      </restriction>
    </simpleType>
    <element name="myHeight" type="tns:height"/>

    <simpleType name="yardLength">
      <restriction base="nonNegativeInteger">
        <minLength value="45"/>
        <maxLength value="205"/>
      </restriction>
    </simpleType>
    <element name="myYardLength" type="tns:yardLength"/>

    <simpleType name="layoutComponentType">
      <restriction base="string">
        <enumeration value="Field"/>
        <enumeration value="Separator"/>
      </restriction>
    </simpleType>
    <element name="layoutComponent" type="tns:layoutComponentType"/>

</schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> getBalanceXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <xsd:complexType name="cinfoct">
                <xsd:sequence>
                        <xsd:element name="customerSurname" type="xsd:string" />
                        <xsd:element name="customerForname" type="xsd:string" />
                        <xsd:element name="branchCode">
                                <xsd:simpleType>
                                        <xsd:restriction base="xsd:string">
                                                <xsd:pattern
                                                        value="[0-9]{2}[\-][0-9]{2}[\-][0-9]{2}" />
                                        </xsd:restriction>
                                </xsd:simpleType>
                        </xsd:element>
                </xsd:sequence>
        </xsd:complexType>
        <xsd:element name="custInfo" type="cinfoct" />
        <xsd:complexType name="accinfct">
                <xsd:sequence maxOccurs="unbounded" minOccurs="0">
                        <xsd:element name="accName">
                                <xsd:simpleType>
                                        <xsd:restriction base="xsd:string">
                                                <xsd:enumeration value="Cheque" />
                                                <xsd:enumeration value="Credit" />
                                                <xsd:enumeration value="Savings" />
                                                <xsd:enumeration value="Loan" />
                                        </xsd:restriction>
                                </xsd:simpleType>
                        </xsd:element>
                        <xsd:element name="accNumber">
                                <xsd:simpleType>
                                        <xsd:restriction base="xsd:string">
                                                <xsd:pattern value="[0-9]{12}" />
                                        </xsd:restriction>
                                </xsd:simpleType>
                        </xsd:element>
                        <xsd:element name="accBalance">
                                <xsd:simpleType>
                                        <xsd:restriction base="xsd:decimal">
                                                <xsd:fractionDigits value="2" />
                                        </xsd:restriction>
                                </xsd:simpleType>
                        </xsd:element>
                </xsd:sequence>
        </xsd:complexType>
        <xsd:element name="accInfo" type="accinfct" />
</xsd:schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> groupXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:tns="http://soapinterop.org/types"
        targetNamespace="http://soapinterop.org/types">

  <group name="priceGroup">
    <annotation>
      <documentation xml:lang="en">
                A price is any one of the following:
                    * Full Price (with amount)
                    * Sale Price (with amount and authorization)
                    * Clearance Price (with amount and authorization)
                    * Free (with authorization)
      </documentation>
    </annotation>
    <choice id="pg.choice">
      <element name="fullPrice" type="decimal"/>
      <element name="salePrice" type="decimal"/>
      <element name="clearancePrice" type="decimal"/>
      <element name="freePrice" type="decimal"/>
    </choice>
  </group>

  <element name="price">
    <complexType>
      <group ref="tns:priceGroup" />
    </complexType>
  </element>

</schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> importAuxXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema targetNamespace="http://soapinterop.org/xsd2"
        xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd1="http://soapinterop.org/xsd2"
        elementFormDefault="qualified">
    <complexType name="SOAPStruct">
        <all>
            <element name="varFloat" type="xsd:float"/>
            <element name="varInt" type="xsd:int"/>
            <element name="varString" type="xsd:string"/>
        </all>
    </complexType>
</schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> importBaseXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema targetNamespace="http://soapinterop.org/xsd"
        xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd1="http://soapinterop.org/xsd"
        xmlns:xsd2="http://soapinterop.org/xsd2"
        elementFormDefault="qualified">
    <import namespace="http://soapinterop.org/xsd2" schemaLocation="importAux.xsd"></import>
    <element name="echoStructParam" type="xsd2:SOAPStruct"/>
</schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> includeWithNamespaceXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<xs:schema
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tns="http://tns.demo.org"
    targetNamespace="http://tns.demo.org"
    attributeFormDefault="unqualified"
    elementFormDefault="qualified">
  <xs:include schemaLocation="src/test/test-resources/includedWithoutNamespace.xsd"/>

  <xs:element name="foo" type="tns:XdwsGroupId"/>
</xs:schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> includeWithoutNamespaceXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<xs:schema
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    attributeFormDefault="unqualified"
    elementFormDefault="qualified">
  <xs:simpleType name="XdwsPrincipalId">
    <xs:restriction base="xs:string"/>
  </xs:simpleType>

  <xs:simpleType name="XdwsGroupId">
    <xs:restriction base="XdwsPrincipalId"/>
  </xs:simpleType>
</xs:schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> listXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:tns="http://soapinterop.org/types"
        targetNamespace="http://soapinterop.org/types">

  <element name="workDays">
    <simpleType>
      <restriction base="tns:daysInWeek">
        <length value="5"/>
      </restriction>
    </simpleType>
  </element>

  <simpleType name="daysInWeek">
    <list itemType="xsd:integer"/>
  </simpleType>

</schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> mixedContentXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema targetNamespace="http://soapinterop.org/xsd"
        xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd1="http://soapinterop.org/xsd"
        xmlns:xsd2="http://soapinterop.org/xsd2"
        elementFormDefault="qualified">
     <element name="complexElt">
         <complexType mixed="true">
             <sequence>
                  <element name="name" type="string"/>
                  <element name="age" type="int"/>
             </sequence>
         </complexType>
     </element>
</schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> notationXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:tns="http://soapinterop.org/types"
        targetNamespace="http://soapinterop.org/types">

  <notation name="teamLogo"
            system="com/team/graphics/teamLogo"
            public="http://www.team.com/graphics/teamLogo"
            id="notation.teamLogo">
    <annotation>
      <documentation xml:lang="en">Location of the corporate logo.</documentation>
    </annotation>
  </notation>

  <notation name="teamMascot"
            system="com/team/graphics/teamMascot"
            public="http://www.team.com/graphics/teamMascot"
            id="notation.teamMascot">
    <annotation>
      <documentation xml:lang="en">Location of the corporate mascot.</documentation>
    </annotation>
  </notation>

  <element name="demoNotation">
    <simpleType>
      <restriction base="NOTATION">
        <enumeration value="tns:teamLogo"/>
        <enumeration value="tns:teamMascot"/>
      </restriction>
    </simpleType>
  </element>

</schema>'
]

{ #category : #accessing }
PPXmlResource >> parserAt: aClass [ 
	^ aClass new "parsers 
		at: aClass name
		ifAbsentPut: [ aClass new ]"
]

{ #category : #'accessing-xsd' }
PPXmlResource >> restrictionXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:tns="http://soapinterop.org/types"
        targetNamespace="http://soapinterop.org/types"
        attributeFormDefault="qualified">

  <simpleType name="drinksize">
    <restriction base="string">
      <enumeration value="small"/>
      <enumeration value="medium"/>
      <enumeration value="large"/>
    </restriction>
  </simpleType>

  <complexType name="dietdrinksize">
    <simpleContent>
      <restriction base="tns:drinksize">
        <enumeration value="small"/>
        <enumeration value="medium"/>
        <attribute name="units" type="string" use="required"/>
        <attribute name="id" type="integer" use="required" default="001"/>
      </restriction>
    </simpleContent>
  </complexType>

</schema>'
]

{ #category : #running }
PPXmlResource >> setUp [
	super setUp.
	parsers := Dictionary new
]

{ #category : #'accessing-xsd' }
PPXmlResource >> simpleContentExtensionXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:tns="http://soapinterop.org/types"
        targetNamespace="http://soapinterop.org/types">

  <element name="ID" type="string"/>

  <element name="Name" substitutionGroup="tns:ID" type="string"/>

  <element name="IDBlock" type="string" block="substitution"/>

  <element name="TestSubstitutionGroup">
    <complexType>
      <sequence>
        <element ref="tns:ID"/>
      </sequence>
    </complexType>
  </element>

</schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> subgroupXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:tns="http://soapinterop.org/types"
        targetNamespace="http://soapinterop.org/types">

  <element name="ID" type="string"/>

  <element name="Name" substitutionGroup="tns:ID" type="string"/>

  <element name="IDBlock" type="string" block="substitution"/>

  <element name="TestSubstitutionGroup">
    <complexType>
      <sequence>
        <element ref="tns:ID"/>
      </sequence>
    </complexType>
  </element>

</schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> unionXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:tns="http://soapinterop.org/types"
        targetNamespace="http://soapinterop.org/types">

  <element name="unionTest">
    <simpleType>
      <union memberTypes="float decimal"/>
    </simpleType>
  </element>

</schema>'
]

{ #category : #'accessing-xsd' }
PPXmlResource >> unqualifiedTypesXsd [
	^ '<?xml version="1.0" encoding="UTF-8"?>
<schema targetNamespace="http://soapinterop.org/xsd"
        xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:xsd1="http://soapinterop.org/xsd"
        xmlns:xsd2="http://soapinterop.org/xsd2"
        elementFormDefault="qualified">
     <element name="complexElt">
         <complexType>
             <sequence>
                  <element name="name" type="string"/>
                  <element name="age" type="int"/>
             </sequence>
         </complexType>
     </element>
</schema>'
]
