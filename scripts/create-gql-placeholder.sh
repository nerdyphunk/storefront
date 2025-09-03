#!/bin/bash
# Create GraphQL placeholder with working toString() method

cat > src/gql/index.ts << 'EOF'
// Auto-generated GraphQL types will be exported from here
// This file is created during postinstall to prevent import errors during SSR

// Temporary exports to prevent build errors
// These will be replaced when GraphQL codegen runs successfully

// Mock GraphQL document class for placeholders
class MockGraphQLDocument {
  constructor(private query: string) {}
  
  toString() {
    return this.query;
  }
}

// Temporary GraphQL queries (basic structure matching real queries)
const PRODUCT_LIST_BY_COLLECTION_QUERY = `
  query ProductListByCollection($slug: String!, $channel: String!) {
    collection(slug: $slug, channel: $channel) {
      name
      description  
      products(first: 100) {
        edges {
          node {
            id
            name
            slug
            pricing {
              priceRange {
                start {
                  gross {
                    amount
                    currency
                  }
                }
              }
            }
            thumbnail(size: 1024, format: WEBP) {
              url
              alt
            }
          }
        }
      }
    }
  }
`;

const PRODUCT_LIST_PAGINATED_QUERY = `
  query ProductListPaginated($first: Int!, $channel: String!) {
    products(first: $first, channel: $channel) {
      edges {
        node {
          id
          name
          slug
          pricing {
            priceRange {
              start {
                gross {
                  amount
                  currency
                }
              }
            }
          }
          thumbnail(size: 1024, format: WEBP) {
            url
            alt
          }
        }
      }
      pageInfo {
        hasNextPage
        hasPreviousPage
        startCursor
        endCursor
      }
    }
  }
`;

const BASIC_PLACEHOLDER_QUERY = `
  query PlaceholderQuery {
    __typename
  }
`;

// Document exports with toString() method and realistic queries
export const CheckoutCreateDocument = new MockGraphQLDocument(BASIC_PLACEHOLDER_QUERY) as any;
export const CheckoutFindDocument = new MockGraphQLDocument(BASIC_PLACEHOLDER_QUERY) as any;
export const CheckoutAddLineDocument = new MockGraphQLDocument(BASIC_PLACEHOLDER_QUERY) as any;
export const CheckoutDeleteLinesDocument = new MockGraphQLDocument(BASIC_PLACEHOLDER_QUERY) as any;
export const ProductListPaginatedDocument = new MockGraphQLDocument(PRODUCT_LIST_PAGINATED_QUERY) as any;
export const ProductListByCollectionDocument = new MockGraphQLDocument(PRODUCT_LIST_BY_COLLECTION_QUERY) as any;
export const ProductDetailsDocument = new MockGraphQLDocument(BASIC_PLACEHOLDER_QUERY) as any;

// Fragment types
export type CheckoutFragmentFragment = any;
export type ProductListItemFragment = any;
export type PageInfo = any;

// TypedDocumentString type
export type TypedDocumentString<TResult, TVariables> = string & {
  __apiType?: (variables: TVariables) => TResult;
};

// Add more exports as needed when GraphQL types are generated
// This is a temporary file to prevent import errors
EOF

echo "✅ Created GraphQL placeholder with working toString() method"
